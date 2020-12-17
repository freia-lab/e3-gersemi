program FV601_SpecMode

int specMode;
int SQ9_state;
int FV601cmdAuto, FV601cmdMan, FV601cmdOpen, FV601cmdClose;
string seq_state;

assign seq_state to "{p1}-Ctrl:SQ9:cFV601-SpecModState";
assign specMode to "{p1}-Ctrl:SQ9:cFV601-SpecMode";
assign SQ9_state to "{p1}-Ctrl:SQ9:sStep";
assign FV601cmdAuto to "{p1}-LHe:FV601:cmdAuto";
assign FV601cmdMan to "{p1}-LHe:FV601:cmdMan";
assign FV601cmdOpen to "{p1}-LHe:FV601:cmdSet";
assign FV601cmdClose to "{p1}-LHe:FV601:cmdRst";

monitor SQ9_state;
monitor seq_state;
monitor specMode;
monitor FV601cmdAuto;
monitor FV601cmdMan;
monitor FV601cmdOpen;
monitor FV601cmdClose;

// Variables for 2K pumps startup sequence
int startupStep;
int SQ13_state;
int SQ17_state;
int autoStartUp_SQ13;
int autoStartUp_SQ17;
int PumpsRdy;
int cmdPumpRst;
int cmdYes_SQ13;
int cmdYes_SQ17;
int cPumpOn;
int holdState;
float pumpSpeed;
float flow;
float cSetV_DV;
float cSetV_WH;
float final_WH_SQ13, final_WH_SQ17;
float rampStep_SQ13, rampStep_SQ17;
float flowLimit_SQ13, flowLimit_SQ17;
string startupStepStr;


// Global PVs
assign SQ13_state to "{p1}-Ctrl:SQ13:sStep";
assign SQ17_state to "{p1}-Ctrl:SQ17:sStep";
assign PumpsRdy to "CstatH-2Kpumps:Ctrl:sRdy2Start";
assign cmdPumpRst to "CstatH-2Kpumps:Ctrl:cmdReset";
assign cmdYes_SQ13 to "CstatV-Ctrl:SQ13:cmdYes";
assign cmdYes_SQ17 to "CstatV-Ctrl:SQ17:cmdYes";
assign pumpSpeed to "CstatH-2Kpumps:AllPumps:sFreq";
assign flow to "CstatH-RHtr:FT551:sRdV";
assign cSetV_DV to "CstatH-2Kpumps:Ctrl-DV:cSetV";
assign cSetV_WH to "CstatH-2Kpumps:Ctrl-WH:cSetV";
assign cPumpOn to "CstatH-2Kpumps:Ctrl:cOn";

// PVs for the sequence
assign startupStep to "{p1}-Ctrl:SQ13/17:cStep2KstartUp";
assign autoStartUp_SQ13 to "{p1}-Ctrl:SQ13:c2KpumpsAuto";
assign autoStartUp_SQ17 to "{p1}-Ctrl:SQ17:c2KpumpsAuto";
assign holdState to "{p1}-Ctrl:SQ13/17:c2KpumpsHold";
assign final_WH_SQ13 to "{p1}-Ctrl:SQ13:cP_WHfinal";
assign final_WH_SQ17 to "{p1}-Ctrl:SQ17:cP_WHfinal";
assign rampStep_SQ13 to "{p1}-Ctrl:SQ13:cP_2KpumpsStep";
assign rampStep_SQ17 to "{p1}-Ctrl:SQ17:cP_2KpumpsStep";
assign flowLimit_SQ13 to "{p1}-Ctrl:SQ13:cP_FT551forStartUp";
assign flowLimit_SQ17 to "{p1}-Ctrl:SQ17:cP_FT551forStartUp";
assign startupStepStr to "{p1}-Ctrl:SQ13/17:sStep2KstartUpStr";

monitor PumpsRdy;
monitor pumpSpeed;
monitor flow;
monitor holdState;
monitor startupStep;

monitor SQ13_state;
monitor SQ17_state;
monitor autoStartUp_SQ13;
monitor autoStartUp_SQ17;
monitor flowLimit_SQ13;
monitor flowLimit_SQ17;
monitor rampStep_SQ13;
monitor rampStep_SQ17;
monitor final_WH_SQ13;
monitor final_WH_SQ17;

ss FV601_sm {

  state init {
    entry {
      sprintf (seq_state, "Init");
      pvPut (seq_state);
      FV601cmdAuto = 0;
      FV601cmdMan = 0;
      FV601cmdOpen = 0;
      FV601cmdClose = 0;
    }
    when (pvConnectCount() == pvAssignCount()) {
      printf ("In state init - all pvs connected\n");
    } state iddle
    when (delay(5) || (pvConnectCount() != pvAssignCount())) {
    } state connect_timeout
  }

  state connect_timeout {
    entry {
      sprintf (seq_state, "Connect time-out");
      pvPut (seq_state);
    }
    when (pvConnectCount() == pvAssignCount()) {} state iddle
    when (delay (3600)) {
      printf ("Leaving state connect_timeout\n");
    } state init
  }

  state iddle {
    entry { 
      sprintf (seq_state, "Iddle");
      pvPut (seq_state);
      printf ("Iddle - Will put FV601 in Auto mode\n");
      FV601cmdAuto = 1;
      pvPut (FV601cmdAuto);     
    }
    when (pvConnectCount() != pvAssignCount()) {} state connect_timeout
    when ((SQ9_state == 18) &&  (specMode != 0)) {} state filling
  }

  state filling {
    entry { 
      sprintf (seq_state, "Filling");
      pvPut (seq_state);
      printf ("Will put FV601 in Manuual and open it\n");
      FV601cmdMan = 1;
      pvPut (FV601cmdMan);
      FV601cmdOpen = 1;
      pvPut (FV601cmdOpen);
    }
    when (pvConnectCount() != pvAssignCount()) { } state connect_timeout
    when ((SQ9_state != 18) ||  (specMode == 0)) {
      printf ("Leaving filling state\n");
    } state iddle
  }
}

ss Pumps_startup {

int time_out = 1800;
int full_speed = 90;
float DV_SP, WH_SP;

  state idle_2K {
   entry {
      startupStep = 0;
      pvPut(startupStep);
      sprintf (startupStepStr, "Idle");	
      pvPut(startupStepStr);
      printf ("Entered idle_2K state\n");	
   }

   when ((SQ13_state == 12) && autoStartUp_SQ13 && PumpsRdy && !holdState) {
   } state start_full_speed
   when ((SQ17_state == 12) && autoStartUp_SQ17 && PumpsRdy && !holdState) {
   } state start_full_speed
   when ((SQ13_state == 12) && autoStartUp_SQ13 && !PumpsRdy && !holdState) {
   } state pumps_reset
   when ((SQ17_state == 12) && autoStartUp_SQ17 && !PumpsRdy && !holdState) {
   } state pumps_reset
   when ((((!autoStartUp_SQ13) && (SQ13_state != 0)) ||
   	((!autoStartUp_SQ17) && (SQ17_state != 0))) && (startupStep == 6)) {
     WH_SP = 0;
     DV_SP = 10;
     cSetV_WH = 0;
     cSetV_DV = 10;
     pvPut (cSetV_WH);
     pvPut (cSetV_DV);
   } state ramping_up
  } 


  state pumps_reset {
     entry {
      	startupStep = 1;
        pvPut(startupStep);
      	printf ("Entered pumps_reset state\n");
        sprintf (startupStepStr, "Resetting the 2K pumps");	
        pvPut(startupStepStr);
	printf ("Send reset command to the pumps\n");
	cmdPumpRst = 1;
	pvPut (cmdPumpRst);
     }
     when (startupStep == 0) {} state idle_2K
     when (delay (5)) {} state idle_2K
  }

  state start_full_speed {
     entry {
        startupStep = 2;
      	pvPut(startupStep);
        sprintf (startupStepStr, "Waiting for achieving the full speed");	
        pvPut(startupStepStr);
      	printf ("Entered start_full_speed state\n");
 	printf ("Set the full speed and send start command to the pumps\n");
        cSetV_WH = 100;
     	cSetV_DV = 100;
     	pvPut(cSetV_WH);
     	pvPut(cSetV_DV);
	cPumpOn = 1;
    	pvPut(cPumpOn);	
    }
     when (startupStep == 0) {} state idle_2K
     when ((pumpSpeed > full_speed) && !holdState) {} state  warm_up
     when (delay(time_out) && !holdState) {} state idle_2K
  }

  state warm_up {
     entry {
        startupStep = 3;
      	pvPut(startupStep);
        sprintf (startupStepStr, "Warming-up at full speed");	
        pvPut(startupStepStr);
      	printf ("Entered warm_up state\n");
    }
     when (startupStep == 0) {} state idle_2K
     when (delay(600) && !holdState) {
     	printf("Warm-up ready - set the WH to 0 and DV to 10\n");
	WH_SP = 0;
	DV_SP = 10;
        cSetV_WH = 0;
     	cSetV_DV = 10;
     	pvPut(cSetV_WH);
     	pvPut (cSetV_DV);
     } state ramping_down
  }

  state ramping_down {
     entry {
        startupStep = 4;
        pvPut(startupStep);
        sprintf (startupStepStr, "Waiting for pumps to slow down");	
        pvPut(startupStepStr);
        printf ("Entered ramping_down state\n");
     }
     when (startupStep == 0) {} state idle_2K
     when (pumpSpeed < 10) {
     	  if (SQ13_state != 0) {
     	    printf("Ramping-down ready - sent Yes command to SQ13\n");
	    cmdYes_SQ13 = 1;
     	    pvPut(cmdYes_SQ13);
	  }
     	  if (SQ17_state != 0) {
     	    printf("Ramping-down ready - sent Yes command to SQ17\n");
	    cmdYes_SQ17 = 1;
     	    pvPut(cmdYes_SQ17);
	  }
       } state awaiting_Step18
  }

  state awaiting_Step18 {
     entry {
        startupStep = 5;
        pvPut(startupStep);
        sprintf (startupStepStr, "Waiting for step 18");	
        pvPut(startupStepStr);
        printf ("Entered awaiting_Step18 state\n");
     }
     when (startupStep == 0) {} state idle_2K
     when (SQ13_state == 18) {} state ramping_up
     when (SQ17_state == 18) {} state ramping_up
  }

   state ramping_up {
     entry {
        startupStep = 6;
        pvPut(startupStep);
        sprintf (startupStepStr, "Ramping up...");	
        pvPut(startupStepStr);
        printf ("Entered ramping_up state\n");
     }
     when (delay(5) && (startupStep == 0)) {} state idle_2K
     when ((SQ13_state != 0) && (WH_SP >= final_WH_SQ13)) {} state idle_2K
     when ((SQ17_state != 0) && (WH_SP >= final_WH_SQ17)) {} state idle_2K
     when (holdState) {} state ramping_up
     when (delay (60) && (flow < flowLimit_SQ13)) {
     	  if (DV_SP < 100) {
	     if (SQ13_state != 0) {
	       DV_SP = DV_SP + rampStep_SQ13;
	     }
	     if (SQ17_state != 0) {
	       DV_SP = DV_SP + rampStep_SQ17;
	     }
	     if (DV_SP > 100) DV_SP = 100;
	     cSetV_DV = DV_SP;
	     pvPut (cSetV_DV);
	  } else {
	     if (SQ13_state != 0) {
	       WH_SP = WH_SP + rampStep_SQ13;
	       if (WH_SP > final_WH_SQ13) WH_SP = final_WH_SQ13;
	     }
	     if (SQ17_state != 0) {
	       WH_SP = WH_SP + rampStep_SQ17;
	       if (WH_SP > final_WH_SQ17) WH_SP = final_WH_SQ17;
	     }
	     cSetV_WH = WH_SP;
	     pvPut (cSetV_WH);
	  }
	  printf ("WH = %f\tDV = %f\n", WH_SP, DV_SP);

     } state ramping_up
   }

}  

