# This should be a test or example startup script

require gersemi

require recsync
require iocstats

epicsEnvSet("IOCNAME", "ioc11-gersemi")

iocshLoad("$(gersemi_DIR)/gersemi.iocsh", "PLC_IP=192.168.1.30, TOP=/opt/epics/autosave, IOCNAME=$(IOCNAME)")

# iocStats database
dbLoadRecords("$(iocstats_DB)/iocAdminSoft-ess.db","IOC=$(IOCNAME)")

# Start recsync client
#iocshLoad("$(recsync_DIR)/recsync.iocsh", "IOCNAME=$(IOCNAME)")
