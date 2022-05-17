# Create a Epics database substitution file based on the content of DB360 data block in the Gersemi PLC.
# Procedure:
# 1. Create a source file of DB360 file (SIMATIC Manager)
# 2. Export the source file to the operating system
# 3. Edit the exported file: 
#        * leave only the content of the structure in the beginning of the file
#        * remove the "_" between the TTxxx and "V", "L" and "M" do the name of the sensor will be
#          like TTxxxM instead of original TTxxx_M
# 4. Run this program as follows:
#        awk -f generate_subst_file.awk < input_file > output file
#             where:
#               input_file - the file created in step 3
#               output_file - the generated substitution file
#        For this IOC the command can look like that when running it in Db directory:
#             awk -f ../../tools/CERNOX/generate_subst_file.awk < ../../doc/CERNOX/cernox_list.txt \
#             > gersemi-cernox-calibr.substitutions       
#
BEGIN {
  a_sw = 36
  aa = 48
  ab = 68
  ac = 88
  ad = 108
  offs = 136
  print "file \"cernox-calibr.template\" { pattern"
  print "{P               D        PORT    DEST         A_SW   A_A   A_B   A_C   A_D }" 
}

{ 
    printf "{CstatV-Ctrl:   %-7s   G_S7    DB360.DBD   %5d %5d %5d %5d %5d }\n",$1,a_sw, aa,ab,ac,ad
    a_sw += offs
    aa += offs
    ab += offs
    ac += offs
    ad += offs
    }
END { print "}\n" }
