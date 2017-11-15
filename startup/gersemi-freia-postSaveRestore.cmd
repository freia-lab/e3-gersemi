#############################################
## Autosave monitor post setup             ##
#############################################

create_monitor_set("ioc-gersemi-freia.req",30,"P=$(AUTOSAVE_SYSM_PV_PREFIX)")

