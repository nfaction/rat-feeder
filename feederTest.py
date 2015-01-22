#! /usr/bin/env python

import serial
ser = serial.Serial('/dev/tty.usbserial-A6004p3O', 9600)
input = ''
rerun = ''

while True:
  input = raw_input('Input feeder commands: ').upper()
  try:
    if(input == 'B'):
      ser.write('B1')
    if(input == 'K'):
      ser.write('K')
    if(input == 'F'):
      ser.write('F1')
    if(input == 'O'):
      ser.write('O')
    if(input == 'C'):
      ser.write('C')
    if('D' in input):
      time = raw_input('Specify pulse time: ')
      command = 'D(' + str(time) + ')'
      ser.write(command)
    if(input == ''):
      ser.write(rerun)
    if(input != ''):
      rerun = input
    if(input == 'E'):
      break
  except serial.SerialException:
    pass
ser.close()