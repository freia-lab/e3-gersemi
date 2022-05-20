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

P="CstatV-Ctrl:"

# Absolute path to this script. /home/user/bin/foo.sh
SCRIPT=$(readlink -f $0)
# Absolute path this script is in. /home/user/bin
SCRIPTPATH=`dirname $SCRIPT`

# Help awk programs (must be in the same directory as this script)
AWKPR1=$SCRIPTPATH/get_coeff.awk
AWKPR2=$SCRIPTPATH/get_switchpoints.awk

if [ -d calibrations ]
then
    cd calibrations
else
    echo " calibration directory missing!"
    exit
fi

cmd="caput $P$1:cPolyA -a 5"
f=CX_LS_$2\(1.5K...4.5K
cf=($f*)
#echo $cf
val=`awk -f $AWKPR1 < $cf`
echo $cmd$val
rlist=(`awk -f $AWKPR2 < $cf`)
#echo rlist1=${rlist[@]}
tmp=${rlist[0]}" < "${rlist[2]}
simple=`echo "$tmp" |bc -l`
#if [ $simple -eq 1 ]
#then
#    echo "simple"
#else
#    echo "complicated"
#fi
if [ $simple -eq 0 ]
then
    r0=${rlist[2]}
fi
cmd="caput $P$1:cPolyB -a 5"
f=CX_LS_$2\(4.5K...20.0K
cf=($f*)
val=`awk -f $AWKPR1 < $cf`
echo $cmd$val
rlist=(`awk -f $AWKPR2 < $cf`)
#echo rlist2=${rlist[@]}
if [ $simple -eq 1 ]
then
    r0=${rlist[2]}
else
    r1=${rlist[1]}
fi

#r0=`tail -1 $cf | awk '{printf " %13.7f", $1}'`

cmd="caput $P$1:cPolyC -a 5"
f=CX_LS_$2\(20.0K...100.0K
cf=($f*)
val=`awk -f $AWKPR1 < $cf`
echo $cmd$val
rlist=(`awk -f $AWKPR2 < $cf`)
#echo rlist=${rlist[@]}
if [ $simple -eq 1 ]
then
    r1=${rlist[2]}
fi
#r1=`tail -1 $cf | awk '{printf " %13.7f", $1}'`

cmd="caput $P$1:cPolyD -a 5"
f=CX_LS_$2\(100.0K...310.0K
cf=($f*)
val=`awk -f $AWKPR1 < $cf`
echo $cmd$val
rlist=(`awk -f $AWKPR2 < $cf`)
#echo rlist=${rlist[@]}
if [ $simple -eq 1 ]
then
    r2=${rlist[2]}
else
    r2=${rlist[0]}
fi
#r2=`tail -1 $cf | awk '{printf " %13.7f", $1}'`

# Switching values

cmd="caput -a $P$1:cSwitchR 3"
echo $cmd $r0 $r1 $r2

