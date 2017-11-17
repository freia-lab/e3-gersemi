TOP=../..
include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE

#----------------------------------------------------
#  Optimization of db files using dbst (DEFAULT: NO)
#DB_OPT = YES

#----------------------------------------------------
# Create and install (or just install)
# databases, templates, substitutions like this

DB += gersemi-General.db
DB += gersemi-AI.template
DB += gersemi-AValves.template
DB += gersemi-DI.template
DB += gersemi-Evalves.template
DB += gersemi-SQ0_1_2.template
DB += gersemi-SQanalog.template
DB += gersemi-SQbinary.template
DB += gersemi-SQbinPar.template
DB += gersemi-Heater1.template
DB += gersemi-Heater2.template
DB += gersemi-PID.template
DB += gersemi-Valves.template
DB += gersemi-freia.substitutions

#----------------------------------------------------
# If <anyname>.db template is not named <anyname>*.template add
# <anyname>_TEMPLATE = <templatename>

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE
