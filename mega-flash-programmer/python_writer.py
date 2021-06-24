import serial
import sys
from functools import partial
import time

if len(sys.argv) != 3:
    print(f'usage: {sys.argv[0]} filename port')
    print('sends all bytes of filename to port at 1000000 baud')
    sys.exit(1)


ser = serial.Serial(sys.argv[2], 9600)
# from https://stackoverflow.com/a/15599648
with open(sys.argv[1], 'rb') as f:
    for byte in iter(partial(f.read, 1), b''):
        print(byte)
        ser.write(byte)
        time.sleep(.1) # this sleep is vital to making this work
        

ser.close()




