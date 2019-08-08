#!/bin/sh

#docker exec -it freeradiusdb mysql -uroot -proot -Dradius -e "ALTER DATABASE radius CHARACTER SET utf8 COLLATE utf8_general_ci" radius
docker cp ./create_stru.sql freeradiusdb:/
docker exec -it freeradiusdb mysql -ufreeradius -pfreeradius -Dradius -e "source /create_stru.sql" radius
docker cp ./procedures.sql freeradiusdb:/
docker exec -it freeradiusdb mysql -uroot -proot -Dradius -e "source /procedures.sql" radius
docker cp ./dumpdata.sql freeradiusdb:/
docker exec -it freeradiusdb mysql -ufreeradius -pfreeradius -Dradius -e "source /dumpdata.sql" radius
