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

		