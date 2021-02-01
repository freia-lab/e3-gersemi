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

