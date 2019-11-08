importPackage(Packages.org.csstudio.opibuilder.scriptUtil);

var macroInput = DataUtil.createMacrosInput(true);
var GersemiAIdevNam = PVUtil.getString(pvArray[0]);

macroInput.put("AI2Macro", GersemiAIdevNam);
widgetController.setPropertyValue("macros", macroInput);
