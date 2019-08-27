#!/bin/sh

docker cp ./radfreecharge.sql freeradiusdb:/
docker exec -it freeradiusdb mysql -ufreeradius -pfreeradius -Dradius -e "source /radfreecharge.sql" radius
docker cp ./iptvcanals.sql freeradiusdb:/
docker exec -it freeradiusdb mysql -ufreeradius -pfreeradius -Dradius -e "source /iptvcanals.sql" radius
docker cp ./iptvpackets.sql freeradiusdb:/
docker exec -it freeradiusdb mysql -ufreeradius -pfreeradius -Dradius -e "source /iptvpackets.sql" radius
