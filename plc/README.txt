GERSEMI_PLC_2019_10_21_End - AJ, 2019-10-21, Changed FC313, FC404, FC556, DB313. 
		Changes done:
		- When sequence 9 is started sequence 8 to start as well automatically
		- Show correct level for LI760 (LT670+LT671)
		- Keep valves FV640, FV641, FV642 and FV643 open when operating one sequence after another. Example:
			start sequence 10 (FV640 opens), stop sequence 10 (FV640 closes) but when starting sequence
 			12 open FV640 again<<<<.15
		- When cooling the 4K tank have CV600 regulating with FT580
		- VAT valves to show warning in GUI if there is an error 

GERSEMI_PLC_2019_11_08 - KG, Added new blocks DB132 and FC132 for preparing data fro MAGLPC PLC. Communication tested
		and works ok. The HeartBeat functionality works, the logic for all boolean variables is missing - there
		is only a placeholder prepared for each bit.

PLC_GERSEMI_2020_02_20 - KG, Added initials conditions in blocks FC205-FC207, FC209, FC210, FC212-FC223.

GERSEMI_PLC_2020_02_21 - KG, Removed Network 3 in FC361 that zeroed R_Ohm depending on #Data_CERNOX.TTxxx.Not_Connected bit.
		This bit is not correctly set anyway - check if it's used at other places!!!!!
		Commented out all calls to FC361 in INST_ANA_CERNOX for the sensors in the vacuum insert.

GERSEMI_PLC_2020_02_27 - KG, Created a backup directory Backup20200221 before doing any changes. 
		Renamed EH650-653 to EH650A-653A and EH654-657 to EH650B-653B. Changed the control thermometer 
		for EH650B-6503B from TT654-TT657 to TT650-653 (common for heaters A and B).
		Added 4 new PT100 thermometers TT654x-657x (spares for TT654-657). Updated Epics buffers for the new 
		thermometers and changed names of existing devices. The following block has been modified:
		DB100, DB101 - compiled from sources
		SymbolTable, DB304, DB313, DB400, DB401
		FC140, FC142, FC404, FC413, FC563
	
GERSEMI_PLC_2020_02_28 - KG, Changed UDT304 - set the XH to TRUE and reinitialized DB304. All analog inputs will be in Normal 
		mode (not Simulated) when this block is loaded to the PLC. Chhecked the consistency of all blocks. 
		Downloaded to the PLC the blocks that has been recompiled: DB304, FC303, FC304, FC371, FC404 and FC470.

GERSEMI_PLC_2020_03_04 - KG, Renamed TIC690-TIC693 to TIC654-TIC657 accordingly. Changed the regulated temperature sensors
		from TT690-TT693 to TT654-657. Updated Sysmbol table, DB100 and DB101 in the source files and compiled them,
		DB312, FC123, FC411, FC557 and FC562.

GERSEMI_PLC_2020_10_15 - KG, Added the missing parameters in SQ22 and SQ23 (the flow limits). Changes in FC563, FC117, FC118,
		DB222, DB223. Changed the threshols for TT644 for ext command for the heaters from 50 to 120K. Due to the
		placement of TT644 its temperature is up to 120K even if there is a LHe in the cryostat (and pt100 sensors are
		not operational). Change in FC413.

GERSEMI_PLC_2020_10_16 - KG, Updated initial values of the COMM_PARAM (DB410) data block according to the last settings.
GERSEMI_PLC_2020_12_01 - KG, Fixed an error in handling the end switches of FV681 (FC405). 
		Added condition for ignoring the Quench_detect signal when the current from the magnet PS is less then a 
		theshold (FC218). In this version the threshold is saved in COMM_PARAM (DB410). The PS current is sent from 
		HNOSS PLC in Datas_PLC_Horizontal (DB130). It is not implemented on HNOSS PLC yet.
		Added conditions on current leads temperature sent to the magLPS PLC (FC132). 
GERSEMI_PLC_2020_12_03 - KG, Added some fields to the genearal part of Epics buffers (V9). Compiled the sources for DB100/DB101.
		Removed old (not working) CV5203 related stuff and added a CstatV-Ctrl:CV5203:sOpenReq PV for use of the 
		Linde IOC sequencer program (steeing of this variable on Gersemi PLC is not done yet).
		Added PV indicating the status of the Quench ignore bit in SQ18.
GERSEMI_PLC_2020_12_09 - KG, Moved the Magnet current threshold for the qunech ignore condition from COMM_PARAM to SQ18 parameters.
		Added possibility to switch between Local (WinCC) and Remote (Epics) modes of operation from Epics.
GERSEMI_PLC_20221_01_27 - KG, TEMPORARY change substituted TT662M with TT663M in FC215 (G7_SQ15)
GERSEMI_PLC_20221_01_30 - KG, Changed only in FC562 (Manage_PID) NW99 - added condition that the FIC581 regulator can be on only
		when switching sequence for 4K circuit is in step 0, 10 or 20.
GERSEMI_PLC_20221_02_03 - KG, Changed control of the current leads heating. In the original version there were PID controllers 
		FIC650-FIC653 used for this purpose (completely wrong - it didn't work). In fact the valves CV650-653 are not 
		controlled directly but via an internal PID controller. The set point for the controller is tha gas flow flow
		(from 0 to 3 m3/h). Removed completely PID controllers FIC650-FIC653 (left the data block unchanged but in the 
		future if we would need more PID controllers we can rename them and use for other purpose).
		Moved all control logic from the Manage_PID function block to Manage_analog_valves. Changed blocks: FC411, FC557
		and FC562).
		Changed the scaling of FT650-FT653: was 10 m3/h, real value is 3 m3/h - 50 slm (stanadard litre per minute). Changed
		blocks DB321 and FC404
		Changed the logic of SQ19 - transition from step 8 to 10. The old logic made that ususally set point for FT653 was
		not ready with ramping to 0 before the sequence stopped. This logic can be changed and the ramping down removed 
		completely. Changed block: FC219.
GERSEMI_PLC_20221_02_25 - KG, Fixed the bug in managing valve CV581 in SQ17 step 14 (closing the valve). The action of this step was
		overwritten by action in the sequence for switching the 2K circuit exhaust (it was blocked in SQ13 but not SQ17).
GERSEMI_PLC_20221_03_15 - KG, Changed the status sent to Epics (FC118): The G7_SQ_ChgCir state (0-3) is substituted with the SQ step 0-22.
		Added step of the subSeq in SQ13 and SQ17.
GERSEMI_PLC_20221_04_01 - KG, Prepared db100/db101 for setting the PID parameters (no code that does it yet). Updated the blocks
		from the source files *_V10.
GERSEMI_PLC_20221_04_06 - KG, Finished support for setting PID parameters from Epics. 
		NOTE: FIC590-FIG593 are not set in F117 (Epics_commands). They are free to use.
GERSEMI_PLC_20221_04_21 - KG, Fixed bug in SQ9 - it was not possible to stop the sequence in step 44.
GERSEMI_PLC_20221_04_22 - KG, Hopefully fixed the bug in SQ18 - CV680 remained open at the last position set by LIC683 regulator.
		Change done in FC562 (Manage_PID), the PID regulator was kept on in step 12 of SQ18.
GERSEMI_PLC_20221_04_23 - KG, Added current leads heating when SQ22 or SQ23 is active and the magnet insert is in the cryostat.
GERSEMI_PLC_20221_04_27 - KG, Added use of the FT581/FT583 limits instead of setpoints in SQ15. Changes in DB215 and FC215.
		Restored original use of TT662 in SQ15 (change done temporary in GERSEMI_PLC_20221_01_27.
GERSEMI_PLC_20221_05_07 - KG, Fixed bugs in SQ9 - stopping the sequence was not correct programs and in some steps missing altogether.
		It was not possible to stop the sequence in step 44. Changed only in FC209 (G7_SQ9).
GERSEMI_PLC_20221_05_18 - KG, Changed the scaling factor of PT681 (from SCA_0_1800 to SCA_0_1333) (FC404).
GERSEMI_PLC_20221_09_08 - KG, Modified the conditions for the current leads temp ok (sent to MagLPS): added checking ove/underrange 
		and set it to FALSE when SQ4 is running.(FC132).
		Added bypassing the hardware magnet_insert bit in SQ4 step 6 and 8 (when the cables to the insert are 
		disconnected) (FC298)
GERSEMI_PLC_20221_09_09 - KG, Added setting the temperature sensors in simulation mode and back in SQ4. SQ4 sequences nad messages
		done. Modified DB204, FC404, FC204, FC461, FC118
GERSEMI_PLC_20221_09_10 - KG, Removed the necessity/possibility to select the type of insert from the GUI. This feature was only
		implemented in WinCC and porting it to Epics seems to be unnecessary. Therefore the variable used to select the insert
		from the GUI is now set automatically in the PLC program based on the hardware bits indicating which insert is connected.
		(FC298).
GERSEMI_PLC_20221_09_13 - KG, Added TT670A-C to the list of simulated temperatures. (DB204, FC404).
		Turned EH650A/B-653A/B and 670AC during steps 6 and 8 of SQ4 (FC563).
		Closed (reset actuation) FV680 during steps 6 and 8 of SQ4 (FC556).
		Turned off LIC683 in SQ4 steps 6,8,10 (FC562)
		Set CV680 to 0 in SQ4 step 6. Opened CV680 with ramp in SQ4 step 10. (FC557).
		Added parameters for SQ4 in DB410.
GERSEMI_PLC_20221_09_22 - KG, Added handling of the current leads cooling during SQ4. Saved initial regulatiom mode of CV650-653 and
		restored in in step 10. Added parameters for the setting of CV650-653 (flow) during steps 6 and 8. The valves will
		be set to these parameters in steps 6 and 8.
GERSEMI_PLC_20221_09_27 - KG, Added handling of the CV581, CV582 and CV583 during SQ4. The PIC controllers (PIC660, PIC660A and PIC681)
		are turned off during steps 6, 8 and 10 and the correcponding control valvae are frozen at the value at the moment of
		entering step 6. Changes in FC557 and FC562.
GERSEMI_PLC_2021_09_29 - KG, Fixed check parameters condition for SQ4 (FC141).
		Added quench related parameters in SQ16 (DB216, FC117, FC118). Added quench validation logic (FC216).
		Added new states for dealing with quench at 4K (FC216).
		Added control of FV642 and FV587 in SQ16 step 8 and 10 (FC556)
		Added control of CV583 in SQ16 step 8 (FC557)
GERSEMI_PLC_2021_10_13 - KG, Changed the EH580 control (FC414) - TS signal is taken from TOR data (process data Ls_c) instead directly 
		from data inputs data block. (now it's possible to simulate the signal).
GERSEMI_PLC_2021_10_27 - KG, Added support for a new control valve CV644 (manual mode only so far). Changed in DB100/DB101 
		(source files *V10), DB307, DB401 and FC407.
GERSEMI_PLC_2021_10_28 - KG, Added support TIC644 PID. (needs to be tested). Used the previous FIC650 PID. Changed the souces for 
		DB100/DB101 (*_V10), DB312, renamed DB518, modified FC411, FC557, FC562 and FC117.
GERSEMI_PLC_2021_11_01 - KG, Finished adding support for TIC644 PID and CV644 (needs to be tested). Added display of P_SEL, I_SEL and 
		D_SEL arguments to CONT_C function (New version of db100/db101 data blocks (V12). Added possibility to turn D_SEL on 
		and off from Epics interface. Changes in FC562, FC557, FC312, DB100 and DB101.
GERSEMI_PLC_2021_11_02 - KG, Set TIC644.XH_API also in step 8 of SQ15 (FC562 NW59)
GERSEMI_PLC_2021_11_03 - KG, Added support for FT644 (DB100/101 source files *_V12, DB304, DB321, DB400, FC404).
		Changed the condition for "Underrange" error from <=Min to <Min (FC304 NW9).
GERSEMI_PLC_2021_11_16 - KG, Added CV644 to SQ1 (FC557).
GERSEMI_PLC_2021_11_17 - KG, Fixed a bug: creating the sHtrOn status (#RR in FC414). It was a logical AND instead of OR of the 
		3 heaters' status.
GERSEMI_PLC_2021_11_22 - KG, Fixed opening of FV641 in SQ15 step 6 amnd 8 (FC556).
GERSEMI_PLC_2021_11_29 - KG, Updated commissioning parameters for SQ15 (db410). Added turning EH641 in SQ15 steps 6-8 when TT665M > 80K. 
		Set the High and Low temperature to 60 and 50 K (values defined in db410) when entering state 6 and restoring the previous
		settings when entering state 10 or stopping SQ15 (FC563).
GERSEMI_PLC_2021_11_30 - KG, Introduced a new states in SQ15: 6 and 7. State5: doing the same as in state 6 - just waiting 180s before 
		proceeding to state 7 after TT608 dropped below 5K. State 7: starting the PID for keeping keepin the ratio between 
		the cold and war GHe at a given level depending of the requested temperature of the mixed gas. The new state transitions
		are ready (not tested). The control of all the valves but CV641 are updated to be the same in the new states 5 and 7 as 
		in the old state 6. 
		Also the control of EH641 has been added in steps 6 to 8: the heater is turned on with the new high and low temperatures
		set to 60 and 50 K until TT664 drops below 80K.
		Introduced a new SQ15 parameter - deltaT that defines the temperature difference between the TT665 and the requested
		temperature of the mixed He gas. Requires update in the protocol definition.
		Changes made in db215, db201, fc117, fc118, fc556, fc557, fc563, fc562.
GERSEMI_PLC_2021_12_01 - KG, Made a new version of EPICS protocol (defined new fields). Recompiled the sources *V13.
		Changes in db100, db101, db215, fc117, fc118, fc215. Added calculation of FT total for magnet insert in 4K mode.
GERSEMI_PLC_2021_12_02 - KG, Continued to work on the new magnet cooling algorithm. Calculated warm GHe flow rate to be used for CV644 
		control. Prepared scaling factors for the new flow meter. Changes in db215,db321, fc215, fc404 and fc562.
GERSEMI_PLC_2021_12_06 - KG, Renamed TIC644 to FIC644. Changes in Mnemonics, db312, db100, db101, fc411 and fc562.
GERSEMI_PLC_2021_12_07 - KG, Made changes to connect P090 pump. Changes in fc402 and fc552.
GERSEMI_PLC_2021_12_08 - KG, Finished modifications needed for the new algorithm of cooling the magnet (SQ15). Modified fc411, fc215, fc557
		and fc562.
GERSEMI_PLC_2021_12_09 - KG, Fixed some misses in SQ15. Modified fc556 and fc215.
GERSEMI_PLC_2021_12_10 - KG, Fixed yest another miss connected to SQ15 (FC557).
		Added support for the vacuum pumps P050 and P060 (FC401, DB100, DB101, DB302, DB401, DB402)
GERSEMI_PLC_2021_12_14 - KG, Fixed a bug in a status read-back of P090 (removed code temporary added to long time ago to simulate the status
		based on the state of SQ1-3.
		Initialized DATA_SCALES (db321) - forgot to do it after changing the scaling factor for FC644.
GERSEMI_PLC_2021_12_16 - KG, Fixed a bug in a control of EH641 (the heating element was  forced to be on if TT644 < 120 K. I have added the
		additional condition that SQ15 is not active. Change in FC413.
GERSEMI_PLC_2021_12_20 - KG, Changed the way of cooling the magnet - now instead of trying to regulate the temperature of cooling GHe (FIC644)
		it is cooled based on the max dT/dL - it is cooled down until the max gradient is reached and the CV601 is closed. At the 
		same time CV644 is fully open and kept open until the dT/dL reaches 2 K/m below then the max value. When this value is reached
		CV644 closes and normal cooling sequence continues.
GERSEMI_PLC_2021_12_21 - KG, Fixed a bug in setting saving the heater limints for EH641 in SQ15 (FC563).
		Added condition for blowing warm GHe in SQ15 when the TT698 < 5K. (FC215). NOTE - this is not finished - it will not work
		when the temperature of the magnet will drop < 80K. The whole steps 5,6 and 7 of SQ15 must be rewritten.
		Set the limits for EH641 in SQ15 to 60 and 70 K (from 50 and 60) (DB410).
GERSEMI_PLC_2021_12_22 - KG, Fixed a baug in handling the restoring the EH641 levels when exiting SQ15.
		Added possibility to stop SQ15 in state 6.
GERSEMI_PLC_2021_12_23 - KG, Code clean-up of SQ15 and related blocks. Removed state 5, state 7 is now used to blow the warm He gas. The
		old sequence parameter deltaT has been changed to SP_FIC644 (set point for FIC644 during state 7). Removed unused code
		ans variables for calculating and controlling the ratio between the warm He gas and the total flow from the insert.
		Changes in FC117, FC118, FC215, FC556, FC557, FC562, FC563 & DB215.
GERSEMI_PLC_2022_04_01 - KG, Fixed an error in the design - transition in SQ15 state 6 -> 8 was based on TT680 which was a pt100 sensor.
		Changed to TT686. TODO - change the names of the corresponding variables for the sequence paramiters from TT680 to TT686_min.
		Changed the condition for transition in SQ15 state 7 -> 6: decreased the deltaT hystheresis from 2K to 1K.
GERSEMI_PLC_2022_04_05 - KG, Changed the condition for using EH641 hetater in SQ15 step6 (FC563). Bybassed the condition for the maximum
		temperature gradient in SQ15 step 6 when the TT665 < 80K (FC215).
GERSEMI_PLC_2022_04_07 - KG, Fixed a bug in managing the valves CV581-583 in SQ4 (they should stay constant but the setting have been changed 
		by the code related to switching between the gas bag and Kaeser compressor. Disabled to start the change when SQ4 is active.
		Removed the conditions for SQ4 parameters to be not equal zero - in fact we want them to be zero (current leads flows) to
		avoid cooling current leads too much when the heaters are disconnected during SQ4.
GERSEMI_PLC_2022_04_08 - KG, Fixed the set-up of quench detection signal - set the negative logic and minimized the delays (FC402).
GERSEMI_PLC_2022_04_11 - KG, Added calculating the total flow from the insert mafnet @4K also in SQ16.
GERSEMI_PLC_2022_04_20 - KG, Changed conditions for the current leads interlock signals sent to maglps PLC (FC132). Changed conditions
		for calculating the total flow from magnet insert @4K - it's also calculated in relevant steps of SQ17 (FC215).
GERSEMI_PLC_2022_04_26 - KG, Changed SQ18 transition from quench detection (step 8) to step 10/14 - now it's possible to proceed when 
		operatore presses "Yes" (it still enables the transition on "Normal state" digital signal high (I9.7) but his signal does not
		exist now.
		Added information about the SQ4 running state to the maglps PLC in order to turn on HV lamp when SQ4 is running (FC132).
GERSEMI_PLC_2022_04_26_1 - KG, Fixed an error in condition for calculating total flow from the magnet insert @4K.(FC215).
GERSEMI_PLC_2022_04_26_1 - KG, Changed commisioning parameter in SQ17 High_Tol_PT660 from 5 to 0.2 in order to avoid too big oscillations
		when turning the PIC660A regulator.
GERSEMI_PLC_2022_04_27 - KG, Modified SQ23:
		Changed threshold on Ext command for EH354 from TT355 < 100 K to TT355 < 50 K (FC413)
		The max flow condition is checked also in step 12 (until now it was checked only in step 14)
		Added turning on all magnet heaters (EH661, EH681, EH682 and EH 689) in step 12 (before it was only EH661) (FC563)
GERSEMI_PLC_2022_04_28 - KG, Added calculating total flow at 2K from the magnet insert and sending it to Epics. Compiled the sources
		_EPICS_EPICS_To_PLC_V14 and _EPICS_PLC_To_EPICS_V14.
GERSEMI_PLC_2022_05_02 - KG, Added delay 0f 500 ms before comparing the magnet currents for checking if the quench should be ignored.
		It is to avoid a possible (although very unlikely) race condition that the power supply will be shut down before 
		the comparison in the PLC will be done (FC130, FC216, FC218).
GERSEMI_PLC_2022_05_03 - KG, Changed the name of the parameter in SQ15 from P_SP_TT680 to P_TT686_min (see GERSEMI_PLC_2022_04_01)
GERSEMI_PLC_2022_06_13 - KG, Added closing CV5203 request reset when SQ9 is not running (when SQ9 is Reset (not stopped in the normal
		way) the open CV5203 request remained active even if the cryostat was not supposed to be kept cold. (FC557)
GERSEMI_PLC_2022_12_19 - KG, using the parameter P_CV602 in sequence 10 step 8 (it was previously used only in step 16).
		Change only in FC557 NW24.
GERSEMI_PLC_2023_03_14 - KG, Modified FC209 (SQ9) to be able to staop it in step 10 (as shown in the grafcet) and 12. Added parallel to
		State_Run the State_Stopping condition to proceed to the next step. (changes in NW12 and NW14).
GERSEMI_PLC_2023_03_21 - KG, Modified FC216 (SQ16) Added 5 seconds delay before transition from state 8 to state 10 in order to have time
		to measure the pressure. Without this delay the transition could be immidiate because we read the "old" (before the quench)
		pressure.
GERSEMI_PLC_2023_03_23 - KG, Modified FC556 (Manage_VALVES) Added logic that keeps FV680 open after quench (states 8 and 10).
