#!/usr/bin/env python3
#
# Prereq:
# pip3 install CHIP-IO requests
#

import CHIP_IO.GPIO as GPIO
import requests
import time

GPIO.setup("XIO-P7", GPIO.OUT) # LED to GND via resistor
GPIO.setup("XIO-P0", GPIO.IN)  # Button to GND

GPIO.input("XIO-P0")

while True:
    GPIO.output("XIO-P7", 1) # "ready"
    GPIO.wait_for_edge("XIO-P0", GPIO.FALLING)
    GPIO.output("XIO-P7", 0)
    r = requests.get('http://192.168.10.61:9292/songs')
    print(r.text)
    time.sleep(1)
