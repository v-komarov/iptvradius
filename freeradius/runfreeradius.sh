#!/bin/sh

<<<<<<< HEAD
/usr/bin/docker run -itd \
=======
docker run -itd \
>>>>>>> 26628ab9bd5d5920e01ad79afc5521750fbe9dd8
--rm \
--name freeradius \
--link freeradiusdb:mysql \
-e RADIUS_LISTEN_IP=* \
-e RADIUS_CLIENTS=secret@127.0.0.1,secret@172.17.0.3,secret@172.17.0.1,secret@10.5.17.33,TVsTreAM@33.0.0.0/8,TVsTreAM@10.6.16.0/24,TVsTreAM@10.5.16.82 \
-p 1812:1812/udp -p 1813:1813/udp \
-e RADIUS_SQL=true \
-e RADIUS_DB_HOST=freeradiusdb \
-e RADIUS_DB_NAME=radius \
-e RADIUS_DB_USERNAME=freeradius \
-e RADIUS_DB_PASSWORD=freeradius \
-e PROXY_DEFAULT_SECRET=secret \
-e ROXY_DEFAULT_AUTH_HOST_PORT=127.0.0.2:1812 \
-e PROXY_DEFAULT_ACC_HOST_PORT=127.0.0.2:1813 \
freeradius:second
