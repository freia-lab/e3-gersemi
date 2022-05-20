# Extract the switching point between the polynomials. The calibration files are of two types.
# The one with the temperature range descending the last switching point are the following
# Switch 1 (cSwitchR[0]) - the last data point in 4.5K...20.0K file
# Switch 2 (cSwitchR[1]) - the last data point in 20.0K...100.0K file
# Switch 3 (cSwitchR[2]) - the last data point in 100.0K...310.0K file
# The one with the temperatures in the ascending order:
# Switch 1 (cSwitchR[0]) - the last data point in 4.5K...20.0K file
# Switch 2 (cSwitchR[1]) - the last data point in 20.0K...100.0K file
# Switch 3 (cSwitchR[2]) - the last data point in 100.0K...310.0K file

BEGIN { n = 0 }
/^[0123456789]/ {
#    print n ": " $1
    if (n == 0) { 
	last = $1 
	first = $1
	n++
    } else {
	if (n == 1) { second = $1 }
	lastbut1 = last
	last = $1
	n++
    }
}
END {
    printf "%13.6f %13.6f %13.6f \n",first,lastbut1,last
}
