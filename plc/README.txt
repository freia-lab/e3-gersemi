GERSEMI_PLC_2019_10_21_End - AJ, 2019-10-21, Changed FC313, FC404, FC556, DB313. 
		Changes done:
		- When sequence 9 is started sequence 8 to start as well automatically
		- Show correct level for LI760 (LT670+LT671)
		- Keep valves FV640, FV641, FV642 and FV643 open when operating one sequence after another. Example:
			start sequence 10 (FV640 opens), stop sequence 10 (FV640 closes) but when starting sequence
 			12 open FV640 again.
		- When cooling the 4K tank have CV600 regulating with FT580
		- VAT valves to show warning in GUI if there is an error 

GERSEMI_PLC_2019_11_08 - KG, Added new blocks DB132 and FC132 for preparing data fro MAGLPC PLC. Communication tested
		and works ok. The HeartBeat functionality works, the logic for all boolean variables is missing - there
		is only a placeholder prepared for each bit.

PLC_GERSEMI_2020_02_20 - KG, Added initials conditions in blocks FC205-FC207, FC209, FC210, FC212-FC223.

GERSEMI_PLC_2020_02_21 - KG, Removed Network 3 in FC361 that zeroed R_Ohm depending on #Data_CERNOX.TTxxx.Not_Connected bit.
		This bit is not correctly set anyway - check if it's used at other places!!!!!
		Commented out all calls to FC361 in INST_ANA_CERNOX for the sensors in the vacuum insert.


