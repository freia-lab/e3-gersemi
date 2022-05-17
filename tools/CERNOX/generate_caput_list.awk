# Generate the caput file from the file used by the WinCC program to load the Cernox
# calibration to the PLC. WinCC uses comma separated file, the input file used here has
# been exported from Excel as a tab separated file and change the decimal point from 
# comma to dot.

BEGIN {
  tag = ""
  sig = ""
  i = 0
  p = "CstatV-Ctrl:"
  sigPoly["A"] = "cPolyA"
  sigPoly["B"] = "cPolyB"
  sigPoly["C"] = "cPolyC"
  sigPoly["D"] = "cPolyD"
  sigPoly["R"] = "cSwitchR"
}

{ 
    split($1, t, ".")
#    print t[1]
#	print "New tag: " t[1]
	tag = t[1]
	name = tag
	d = substr(t[2],0, 1)
	sub("_", "" , name)
	if (sig != d) {
# A new PV
	    if (d == "R") { n = 3 } else { n = 5 }
	    printf "\ncaput -a %s%s:%s %d %f", p, name, sigPoly[d], n, $2
	    sig = d
	} else {
# The same PV
	    printf " %f", $2
	}
}

END { printf "\n" }
