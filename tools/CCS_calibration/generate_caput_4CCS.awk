# Generate the caput file from the file created by the Excel program (Summary tab)(*prn)
# Redirect the output of this file to <calibration_commands> and then run
# "sh <calibration_commands>" or pipe the output of this program to sh in order to 
# load the new calibrations to the PLC.

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

function polyData(line)
{
    split(substr(line, index(line, "y = ")+4), arr)
    a1 =  substr(arr[1],0, length(arr[1])-2)
    a2 =  substr(arr[3],0, length(arr[3])-2)
    a3 =  substr(arr[5],0, length(arr[5])-2)
    a4 =  substr(arr[7],0, length(arr[7])-2)
    data = sprintf ("%s %s%s %s%s %s%s %s%s", a1,arr[2],a2,arr[4],a3,arr[6],a4,arr[8],arr[9])
    return data
}

($1 != "#") && ($1 != "\r") { 
#    print $1
    if (substr($1,0,2) == "TT") {
	name = $1
	sub("_", "" , name)
#	print "New PV:", name
    } else {
	if ($1 == "R_Switch") {
#	    print $0
	    printf "caput -a %s%s:%s 3 %f %f %f\n", p, name, sigPoly["R"], $2, $3, $4
	} else {
#	    print $0
	    printf "caput -a %s%s:%s 5 %s\n", p, name, sigPoly[$2], polyData($0)
	}
    }
}

