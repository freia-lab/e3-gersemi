#!/bin/bash
#
# Bash script to create caput commands to load the CERNOX calibration data for a given PV
# using a given sensor id
#
# Usage: should be started in the e3-gersemi/doc/CERNOX directory

# for example:
#  ../../generate_calibr_cmds.sh TT353 X79174
#
# It will generate the commands and send them to the standard output.

P="Cstatv-Ctrl:"

if [ -d calibrations ]
then
cd calibrations
else
echo " calibration directory missing!"
exit
fi
