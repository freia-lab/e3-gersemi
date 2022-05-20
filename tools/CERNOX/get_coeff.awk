# Extract the polynomial coefficients A0 to A4 from the calibration file
#
/A[01234]=/ {printf " %16.10f", $2 }
END { printf "\n" }
