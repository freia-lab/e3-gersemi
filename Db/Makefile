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

DB += General.db
DB += AI.template
DB += AValves.template
DB += DI.template
DB += Evalves.template
DB += SQ0_1_2.template
DB += SQanalog.template
DB += SQbinary.template
DB += SQbinPar.template
DB += Heater1.template
DB += Heater2.template
DB += PID.template
DB += Valves.template
DB += gersemi-freia.substitutions

#----------------------------------------------------
# If <anyname>.db template is not named <anyname>*.template add
# <anyname>_TEMPLATE = <templatename>

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE
