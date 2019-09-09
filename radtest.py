#!/usr/bin/python

import radius
import binascii




mac = '90E6BA8B16C5'

r = radius.Radius('TVsTreAM', host='33.16.2.3')



for address in ('239.1.21.3','226.110.10.128'):

    ip = '{:02X}{:02X}{:02X}{:02X}'.format(*map(int, address.split('.')))

    print mac,address
    attrs = {
             'Framed-IP-Address':binascii.unhexlify(ip)
             }

    print(r.authenticate(mac,mac, attributes=attrs))

