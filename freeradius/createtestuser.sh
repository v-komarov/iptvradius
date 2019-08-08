#!/bin/sh

docker exec -it freeradius mysql -ufreeradius -pfreeradius -hmysql -e "insert into radcheck (username, attribute, op, value) values ('test', 'Cleartext-Password', ':=', 'test');" radius
