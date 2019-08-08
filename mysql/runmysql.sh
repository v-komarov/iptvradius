#!/bin/sh

docker run -d --name freeradiusdb \
--rm \
-e MYSQL_ROOT_PASSWORD=root \
-e MYSQL_DATABASE=radius \
-e MYSQL_USER=freeradius \
-e MYSQL_PASSWORD=freeradius \
#-v /var/lib/mysql \
mysql:second
