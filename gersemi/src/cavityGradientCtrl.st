program cavityGradientCtrl

// ************ Gradient Control ***********
// The control is done in  SQ10 step 8 using valves CV601 and CV602.
// When the sequence enters step 8 the CV602 is fully closed.
// When the deltaT becomes bigger then CstatV-Ctrl:SQ10:P_dTmin the 
// program will open CV602 to the value specfied in CstatV-Ctrl:SQ10:P_CV602Max
// in steps of CstatV-Ctrl:SQ10:P_CV602Step. CV602 will be kept at 
// CstatV-Ctrl:SQ10:P_CV602Max (can be changed during the state of regulating CV601)
// until the temperature of the top part of the cavity drops below END_REG_TEMP (50 K).
//  At this time the CV602 will be completely closed and CV601 completely open. 

// When exiting step 8 the parameter CstatV-Ctrl:SQ10:cP_CV602 will be set back to
// the value saved just before starting to open CV602. This parameter is used 
// in step 16 (filling the cryostat in intermittent mode).

// During the time CV602 is fully open CV601 is used for keeping the temperature
// gradient under control using the following algorithm:
// Every CstatV-Ctrl:SQ10:P_ctrlPeriod second when deltaT > CstatV-Ctrl:SQ10:P_dTmax
// close CV601 by CstatV-Ctrl:SQ10:P_CV601Step
// until cv601MIN value is reached or deltaT drops below CstatV-Ctrl:SQ10:P_dTmax
// When deltaT becomes < CstatV-Ctrl:SQ10:P_dTmin start to open CV601 by 
// CstatV-Ctrl:SQ10:P_CV601Step until deltaT reaches CstatV-Ctrl:SQ10:P_dTmin


// Variables for control of cavity gradient in SQ10 step 8

int startupStep;
int seq_state;
int watchdog;

int END_REG_TEMP = 50;   // bottom Temperature at which regulation ends

float cv601, cv602, ttop, tbtm, lastdT, step;
float cv602max, cv602step, cv601min, cv601step, dTmin, dTmax;
float ctrlPeriod;

// Global PVs
assign cv601 to "CstatV-Ctrl:SQ10:cP_CV601";
assign cv602 to "CstatV-Ctrl:SQ10:cP_CV602";
assign ttop to "CstatV-LHe:TT665L:sRdV";
assign tbtm to "CstatV-LHe:TT663L:sRdV";
assign step to "CstatV-Ctrl:SQ10:sStep";
assign watchdog to "CstatV-Ctrl:SQ10:CtrlPrg-WD";
assign seq_state to "CstatV-Ctrl:SQ10:Step8-state";
assign cv602max to "CstatV-Ctrl:SQ10:P_CV602Max";
assign cv602step to "CstatV-Ctrl:SQ10:P_CV602Step";
assign cv601min to "CstatV-Ctrl:SQ10:P_CV601Min";
assign cv601step to "CstatV-Ctrl:SQ10:P_CV601Step";
assign dTmin to "CstatV-Ctrl:SQ10:P_dTmin";
assign dTmax to "CstatV-Ctrl:SQ10:P_dTmax";
assign ctrlPeriod to "CstatV-Ctrl:SQ10:P_ctrlPeriod";

monitor ttop;
monitor tbtm;
monitor step;
monitor seq_state;
monitor cv602max;
monitor cv602step;
monitor cv601min;
monitor cv601step;
monitor dTmin;
monitor dTmax;
monitor ctrlPeriod;

ss cavityGradientCtrl {

int time_out = 1800;
float deltaT;
float  saved_sq10_P_cv602;
int INIT = 0;
int OPENING_CV602 = 1;
int CONTROLLING_CV601 = 2;
int WAITING_4_EXITING_STEP8 = 3;
int DONE = 4;

  state idle {
     entry {
        watchdog = 1;
        seq_state = INIT;
	pvPut (seq_state);
      	printf ("cavityGradientCtrl: Entered idle state\n");	
	if (pvPut(watchdog) != pvStatOK) {
	   printf ("cavityGradientCtrl: Error -  watchdog not updated\n");
	}
     }
     when ((step == 8) && delay(ctrlPeriod) && ((ttop - tbtm) > dTmin)) {
	   pvGet (cv602);
   	   saved_sq10_P_cv602 = cv602;
     } state openingCV602

     when (delay(ctrlPeriod)) {
        watchdog = 1;
	if (pvPut(watchdog) != pvStatOK) {
	   printf ("cavityGradientCtrl: Error -  watchdog not updated\n");
	}
     } state idle
  }


  state openingCV602 {
     float newVal;
     entry {
        cv602 = 0;
        watchdog = 1;
	pvPut(watchdog);
        seq_state = OPENING_CV602;
	pvPut (seq_state);
      	printf ("cavityGradientCtrl: Entered OPENING_CV602 state\n");
     }
     when (delay (10) && (cv602 < cv602max)) {
	  newVal = cv602 + cv602step;
	  (newVal > cv602max) ? (cv602 = cv602max) : (cv602 = newVal);
	  pvPut (cv602);
          watchdog = 1;
	  pvPut (watchdog);
     } state openingCV602
     when (cv602 == cv602max) {} state controllingCV601
  }

  state controllingCV601 {
     float newVal;
     entry {
        pvGet(cv601);
        seq_state = CONTROLLING_CV601;
	pvPut (seq_state);
      	printf ("cavityGradientCtrl: Entered CONTROLLING_CV601 state\n");
     }
     when (ttop < END_REG_TEMP) {
     	  cv601 = 100;
	  pvPut(cv601);
	  cv602 = 0;
	  pvPut(cv602);
     } state waiting4exitStep8
     when (delay(ctrlPeriod)) {
     	  if (cv602 != cv602max) {
	     cv602 = cv602max;
     	     pvPut (cv602);
	  }
     	  deltaT = ttop - tbtm;
          if (deltaT < dTmin) {
     	     newVal = cv601 + cv601step;
     	     (newVal > 100) ? (cv601 = 100.0) : (cv601 = newVal);
	     pvPut (cv601);
	  } else {
	     if (deltaT > dTmax) {
     	     	newVal = cv601 - cv601step;
     	     	(newVal <  cv601min) ? (cv601 = cv601min) : (cv601 = newVal);
		pvPut (cv601);
	     }
	  }
          watchdog = 1;
	  pvPut(watchdog);	  
     } state  controllingCV601
  }

  state waiting4exitStep8 {
     entry {
        watchdog = 1;
	pvPut(watchdog);	  
        seq_state = WAITING_4_EXITING_STEP8;
	pvPut (seq_state);
      	printf ("cavityGradientCtrl: Entered WAITING_4_EXITING_STEP8 state\n");
     }
     when (delay(10) && step != 8) {
     	  cv602 = saved_sq10_P_cv602;
	  pvPut (cv602);
          watchdog = 1;
	  pvPut(watchdog);
     } state idle
     when (delay(ctrlPeriod)) {
          watchdog = 1;
	  pvPut(watchdog);	  
     } state waiting4exitStep8
  }
}  

