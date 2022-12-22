
from epics import PV

class ValveControl:
    debug = 0
    cv601 = None
    cv602 = None
    ft581 = None
    ft581max = None
    ttop = None
    tbtm = None
    lastdT=0
    step = None
    state = None
    INIT = 0
    OPENING_CV602 = 1
    CONTROLLING_CV601 = 2
    LIMITING_FLOW = 3
    DONE = 4

    def __init__(self, dbgLvl=0):
        self.debug =  dbgLvl
        print("**** Connecting to Pvs *****")
        self.cv601 = PV('CstatV-Ctrl:SQ10:cP_CV601')
        self.cv602 = PV('CstatV-Ctrl:SQ10:cP_CV602')
        self.ft581 = PV('CstatV-RHtr:FT581:sRdV')
        self.ft581max = PV('CstatV-Ctrl:SQ10:sP_SP_FIC581')
        self.ttop = PV('CstatV-LHe:TT665L:sRdV')
        self.tbtm = PV('CstatV-LHe:TT663L:sRdV')
        self.step = PV('CstatV-Ctrl:SQ10:sStep')
        self.watchdog = PV('CstatV-Ctrl:SQ10:CtrlPrg-WD')
        self.state = PV('CstatV-Ctrl:SQ10:Step8-state')
        self.cv602max = PV('CstatV-Ctrl:SQ10:P_CV602Max')
        self.cv602step = PV('CstatV-Ctrl:SQ10:P_CV602Step')
        self.cv601min = PV('CstatV-Ctrl:SQ10:P_CV601Min')
        self.cv601step = PV('CstatV-Ctrl:SQ10:P_CV601Step')
        self.dTmin = PV('CstatV-Ctrl:SQ10:P_dTmin')
        self.dTmax = PV('CstatV-Ctrl:SQ10:P_dTmax')
        if self.debug > 0:
            print ("cP_CV601:", self.cv601.value)
            print ("cP_CV602:", self.cv602.value)
            print("FT581:", self.ft581.get(None,None,None,None,None,True))
            print("sP_SP_FIC581;", self.ft581max.value)
            print("Ttop:",self.ttop.value,"\tTbtm:",  self.tbtm.value)
            print("SQ10 step:", self.step.value)
            print("State:", self.state.char_value, "(", self.state.value, ")") 
            print("CV602 Max:", self.cv602max.value)
            print("CV602 step:", self.cv602step.value)        
            print("CV601 Min:", self.cv601min.value)
            print("CV601 step:", self.cv601step.value)
            print("dT Min:", self.dTmin.value)
            print("dT Max:", self.dTmax.value)

    ''' 
************ Gradient Control ***********
The control is done in  SQ10 step 8 using valves CV601 and CV602.
When the sequence enters step 8 the CV602 is fully closed.
When the deltaT becomes bigger then CstatV-Ctrl:SQ10:P_dTmin the 
program will open CV602 to the value specfied in CstatV-Ctrl:SQ10:P_CV602Max
in steps of CstatV-Ctrl:SQ10:P_CV602Step. CV602 will be kept at the same value 
until the temperature of the top part of the cavity drops below 50 K. At this 
time the CV602 will be completely closed and CV601 completely open. 

TODO: When exiting step 8 set the parameter CstatV-Ctrl:SQ10:cP_CV602 back to
the initial value required in step 16 (filling the cryostat in intermittent mode).

During the time CV602 is fully open CV601 is used for keeping the temperature
gradient under control using the following algorithm (to be tested):
Every time gradientCtrl method is called when deltaT >  CstatV-Ctrl:SQ10:P_dTmax
close CV601 by CstatV-Ctrl:SQ10:P_CV601Step
until cv601MIN value is reached or deltaT drops below CstatV-Ctrl:SQ10:P_dTmax
When deltaT becomes < CstatV-Ctrl:SQ10:P_dTmin start to open CV601 by 
CstatV-Ctrl:SQ10:P_CV601Step until deltaT reaches CstatV-Ctrl:SQ10:P_dTmin
    '''
        
    def gradientCtrl(self):
        # Update the watchdog
        self.watchdog.value = 1
        if self.debug > 1:
            print(self.state.char_value)
        if self.state.char_value == 'Done':
            print('If the program exits on start change the State form "Done" to "Init"')
            return False

        if self.debug > 1:
            print ("In SQ10 step %d, " % self.step.value ,"state:", self.state.char_value)

        if self.step.value != 8:
            return True
        if self.debug > 1:
            print ("In step 8, state", self.state.char_value)
        if self.state.value == self.INIT:
            self.waiting()
        if self.state.value == self.OPENING_CV602:
            self.openingCV602()
        if self.state.value == self.CONTROLLING_CV601:
            self.regulatingCV01()
        if self.state.value == self.LIMITING_FLOW:
            self.pausing()

        return True

    # In Init mode waiting for the delta T to be bigger then dTmin
    #               
    def waiting(self):
        deltaT =  self.ttop.value - self.tbtm.value
        self.cv602.value = 0
        if deltaT > self.dTmin.value:
            self.state.value = self.OPENING_CV602

    # Opening slowly CV602
    #
    def openingCV602(self):
        newSP = self.cv602.value + self.cv602step.value
        if newSP >= 100.0:
            self.cv602.value = 100.0
            self.state.value = self.CONTROLLING_CV601
        else:
            self.cv602.value = newSP

    # Regulating CV601
    #
    def regulatingCV01(self):
        if self.ft581.value > self.ft581max.value:
            self.state.value = self.LIMITING_FLOW
            return
        if self.ttop.value < 50:
            self.state.value = self.DONE
            self.cv601.value = 100
            self.cv602.value = 0
            return
        deltaT = self.ttop.value - self.tbtm.value
        if deltaT < self.dTmin.value:
            newSP = self.cv601.value + self.cv601step.value
            if newSP >= 100:
                self.cv601.value = 100.0
            else:
                self.cv601.value = newSP
            return
        if deltaT > self.dTmax.value:
           newSP = self.cv601.value - self.cv601step.value
           if newSP < self.cv601min.value:
               self.cv601.value =  self.cv601min.value
           else:
               self.cv601.value = newSP
        return

    # Flow too high - pausing
    #
    def pausing(self):
        if self.ft581.value < self.ft581max.value:
            self.state.value = self.CONTROLLING_CV601
