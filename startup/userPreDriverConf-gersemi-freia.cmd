###################################################################
## User provided PLC or fast controller driver pre configuration ##
###################################################################

#var s7plcDebug <level>
#level=-1:  no output
#level=0:   errors only
#level=1:   startup messages
#level=2: + output record processing
#level=3: + inputput record processing
#level=4: + driver calls
#level=5: + io printout
#be careful using level>1 since many messages may introduce delays

#var s7plcDebug 2
#s7plcConfigure name,IPaddr,port,inSize,outSize,bigEndian,recvTimeout,sendIntervall
#connects to PLC <name> on address <IPaddr> port <port>
#<inSize>        : size of data block PLC -> IOC [bytes]
#<outSize>       : size of data block IOC -> PLC [bytes]
#<bigEndian>=1   : motorola format data (MSB first)
#<bigEndian>=0   : intel format data (LSB first)
#<recvTimeout>   : time to wait for input before disconnecting [ms]
#<sendIntervall> : time to wait before sending new data to PLC [ms]

#s7plcConfigure PLC:GERSEMI,192.168.1.20,2000,9448,6910,1,1000,500
s7plcConfigure PLC:GERSEMI,$(IP_ADDR),2000,9448,6910,1,1500,500
