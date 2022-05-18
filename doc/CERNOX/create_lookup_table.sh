#!/bin/bash
awk '/TT/ && !/S/ {print $1, $2}' <Affectation_CERNOX_GERSEMI.txt | sed '{s/CV//}' |awk '{ if (substr($1,6) == "UU") {t=substr($1,0,5); printf "%sL %s\n",t,$2; printf "%sM %s\n",t,$2; printf "%sV %s\n",t,$2 } else {print $0}}'

