#!//usr/bin/python3

import time
import sys
import epics

from valveControl import ValveControl

def main():
    print("\n*** Startig the valve control ***")
    vc = ValveControl(2)
    while True:
        if run(vc):
            time.sleep(2)
        else:
            time.sleep(5)
            quit()

def run(vc):
    return vc.gradientCtrl()

if __name__ == "__main__":
    main()
