# Extract the switching point between the polynomials. The calibration files are of two types.
# The one with the temperature range descending the last switching point are the following
# Switch 1 (cSwitchR[0]) - the last data point in 4.5K...20.0K file
# Switch 2 (cSwitchR[1]) - the last data point in 20.0K...100.0K file
# Switch 3 (cSwitchR[2]) - the last data point in 100.0K...310.0K file
# The one with the temperatures in the ascending order:
# Switch 1 (cSwitchR[0]) - the last data point in 4.5K...20.0K file
# Switch 2 (cSwitchR[1]) - the last data point in 20.0K...100.0K file
# Switch 3 (cSwitchR[2]) - the last data point in 100.0K...310.0K file

function abs(a)
{
    if (a >= 0) { return a }
    if (a < 0) { return -a }
}

BEGIN { n = 0 }
/^[0123456789]/ {
#    print n ": " $1
    if (n == 0) { 
	last = $1 
	last_err = $4
	first = $1
	first_err = $4
	n++
    } else {
	if (n == 1) { second = $1; second_err = $4 }
	lastbut1 = last
	lstbut1_err = last_err
	last = $1
	last_err = $4
	n++
    }
}
END {
    printf "%13.6f %13.6f %13.6f %13.6f %6.3f %6.3f %6.3f %6.3f\n",\
	first,second,lastbut1,last, abs(first_err), abs(second_err), abs(lstbut1_err), abs(last_err)
}
