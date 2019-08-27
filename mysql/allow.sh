#!/bin/sh

#docker exec -it freeradiusdb mysql -ufreeradius -pfreeradius -Dradius -e "SELECT DISTINCT ip FROM IPTV_canals;" \
#-B |sed "1d" |sed "s/'/\'/;s/\t/;/g;s/^//;s/$//;s/\n//g" 
docker cp ./all.sql freeradiusdb:/
docker exec -it freeradiusdb mysql -ufreeradius -pfreeradius -Dradius -e "source /all.sql" radius
