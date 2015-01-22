#! /usr/bin/env python

import serial
ser = serial.Serial('/dev/tty.usbserial-A6004p3O', 9600)

for i in range(10):
	try:
	  ser.write('F1')
	  ser.write('B1')
	except serial.SerialException:
	  pass
ser.close()