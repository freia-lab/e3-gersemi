from org.csstudio.display.builder.runtime.script import PVUtil

signal = PVUtil.getString(pvs[0])
print signal
widget.getPropertyValue("macros").add("T", signal)
