BEGIN {
	start = 0
}
{
	if (start != 0 && $0 != "" && NF == 8) printf "%.2f, %.3f\n%.2f, %.3f\n%.2f, %.3f\n%.2f, %.3f\n", $1,$2,$3,$4,$5,$6,$7,$8 
	else
	    if (start != 0 && $0 != "" && NF == 6) printf "%.2f, %.3f\n%.2f, %.3f\n%.2f, %.3f\n", $1,$2,$3,$4,$5,$6
	    else
		if (start != 0 && $0 != "" && NF == 4) printf "%.2f, %.3f\n%.2f, %.3f\n", $1,$2,$3,$4
	        else
		    if (start != 0 && NF == 2) printf "%.2f, %.3f\n", $1,$2

if (start == 0 && ($1 == "R,Ohm" && $2 == "T,K")) start = 1
}
