#!/usr/bin/python

import struct, sys

if len(sys.argv) != 2:
	print("Please specify the path to gk20a_ctxsw.bin to extract the firmware")
	sys.exit(1)

def get_int(blob, pos):
	return struct.unpack('<i', blob[pos:pos + 4])[0]

blob = open(sys.argv[1], 'r').read()

n_regions = get_int(blob, 4)

for i in range(n_regions):
	f = None
	rtype = get_int(blob, 8 + i * 12)
	rlen = get_int(blob, 12 + i * 12)
	rstart = get_int(blob, 16 + i * 12)
	
	if rtype == 0:
		f = open('nvea_fuc409d', 'wb')
	elif rtype == 1:
		f = open('nvea_fuc409c', 'wb')
	elif rtype == 2:
		f = open('nvea_fuc41ad', 'wb')
	elif rtype == 3:
		f = open('nvea_fuc41ac', 'wb')

	if f:
		f.write(blob[rstart:rstart + rlen])
