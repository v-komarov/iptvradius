#!/bin/sh

docker run -d --name oracli --rm \
--link freeradiusdb:mysql \
oracli:second
