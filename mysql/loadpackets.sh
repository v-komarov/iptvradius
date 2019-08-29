#!/bin/sh

docker cp ./iptvpackets.sql freeradiusdb:/
docker exec -it freeradiusdb mysql -ufreeradius -pfreeradius -Dradius -e "source /iptvpackets.sql" radius
#docker exec -it freeradiusdb mysql -ufreeradius -pfreeradius -Dradius -e "SELECT ip,raion FROM IPTV_canals WHERE ip NOT IN (SELECT ip FROM radfreecharge);" \
#-B |sed "1d" |sed "s/'/\'/;s/\t/;/g;s/^//;s/$//;s/\n//g" 
docker cp ./radpackets.sql freeradiusdb:/
docker exec -it freeradiusdb mysql -ufreeradius -pfreeradius -Dradius -e "source /radpackets.sql" 
docker cp ./beforeauth.sql freeradiusdb:/
docker exec -it freeradiusdb mysql -ufreeradius -pfreeradius -Dradius -e "source /beforeauth.sql" 
docker exec -it freeradiusdb mysql -ufreeradius -pfreeradius -Dradius -e "call beforeauth_work('238.1.1.33','001A79102F57');" 
