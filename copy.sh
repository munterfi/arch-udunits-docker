#!/usr/bin/env bash
./build.sh
docker create -ti --name dummy udunits-configure bash
docker cp dummy:/usr/local/src/udunits-configure.tar.gz ./
docker rm -f dummy
