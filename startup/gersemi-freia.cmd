#require autosave

epicsEnvSet("AUTOSAVE_SYSM_PV_PREFIX","gersemi:")

#############################################
## Register all support components         ##
#############################################

requireSnippet(userPreDriverConf-gersemi-freia.cmd, IP_ADDR=$(PLC_IPADDR))
requireSnippet(dbToLoad-gersemi-freia.cmd)
#requireSnippet(gersemi-freia-preSaveRestore.cmd)

#############################################
## IOC initialization                      ##
#############################################

iocInit

#requireSnippet(gersemi-freia-postSaveRestore.cmd)
requireSnippet(userPostDriverConf-gersemi-freia.cmd)

