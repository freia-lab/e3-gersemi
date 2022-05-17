# Generate the list of sensors found the file used by the WinCC program to load the Cernox
# calibration to the PLC. WinCC uses comma separated file, the input file used here has
# been exported from Excel as a tab separated file and change the decimal point from 
# comma to dot.

BEGIN {
  tag = ""
}

{
    split($1, t, ".")
    if (tag != t[1]) {
	tag = t[1]
	name = t[1]
	sub("_", "" , name)
	print name
    }
}
