#!/bin/sh

docker run -d --name oracli \
--link freeradiusdb:mysql \
oracli:second
