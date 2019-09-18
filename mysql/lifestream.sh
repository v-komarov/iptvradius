#!/bin/sh

docker cp ./LifeStream.sql freeradiusdb:/
docker exec -it freeradiusdb mysql -ufreeradius -pfreeradius -Dradius -e "source /LifeStream.sql" radius
