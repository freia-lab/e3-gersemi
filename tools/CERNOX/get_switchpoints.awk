# Extract the switching point between the polynomials. The calibration files are of two types.
# The one with the temperature range descending the last switching point are the following
# Switch 1 (cSwitchR[0]) - the last data point in 4.5K...20.0K file
# Switch 2 (cSwitchR[1]) - the last data point in 20.0K...100.0K file
# Switch 3 (cSwitchR[2]) - the last data point in 100.0K...310.0K file
# The one with the temperatures in the ascending order:
# Switch 1 (cSwitchR[0]) - the last data point in 4.5K...20.0K file
# Switch 2 (cSwitchR[1]) - find the 20 K entry in 4.5K...20.0K and put it in the last entry, 
#          find the 20 K entry in 20.0K...100.0K file and put it in the first entry
# Switch 3 (cSwitchR[2]) - the last data point in 100.0K...310.0K file

function abs(a)
{
    if (a >= 0) { return a }
    if (a < 0) { return -a }
}
function round(x)
{
    return int(x+0.5)
}

BEGIN { n = 0 }
/^[0123456789]/ {
#    print n ": " $1
    if (n == 0) { 
	last = $1 
	last_err = $4
	last_t = round($2)
	first = $1
	first_err = $4
	first_t = round($2)
	n++
    } else {
	if (n == 1) { second = $1; second_err = $4 ; second_t = round($2) }
	lastbut1 = last
	lastbut1_err = last_err
	lastbut1_t = last_t
	last = $1
	last_err = $4
	last_t = round($2)
	n++
    }
}
END {
#    printf "%13.6f %13.6f %13.6f %13.6f %6.3f %6.3f %6.3f %6.3f\n",\
#	first,second,lastbut1,last, abs(first_err), abs(second_err), abs(lstbut1_err), abs(last_err)
    if (last_t > first_t) {
	if ((last_t - first_t) < 10) {
# 1.5 .. 4.5
	    printf "1 %13.6f\n", last
	} else {
	    if ((last_t - first_t) < 20) {
# 4.5 .. 20.0
		if (lastbut1_t == 20) {
		    printf "1 %13.6f %6.3f\n", lastbut1, lastbut1_err
		} else {
		    printf "1 %13.6f %6.3f\n", last, last_err
		}
	    } else {
		if ((last_t - first_t) < 90) {
# 20.0 .. 100.0
		    if (first_t == 20) {
			printf "1 %13.6f %6.3f %d\n", first, first_err, first_t
		    } else {
			printf "1 %13.6f %6.3f %d\n", second, second_err, second_t
		    }
		} else {
# 100.0 .. 310.0
			printf "1 %13.6f %6.3f\n", first, first_err
		}
	    }
	}
    } else {
	printf "0 %13.6f\n", last
    }
}
