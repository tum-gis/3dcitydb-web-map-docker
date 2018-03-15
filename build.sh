#!/bin/bash
# Build 3DCityDB WEb Map Client images ########################################
# Set registry and image name
REPOSITORY="tumgis"
IMAGENAME="3dcitydb-web-map"
# Set versions to build
declare -a versions=("v1.1.0" "v1.4.0")

# build all version
for i in "${versions[@]}"
do
  docker build --build-arg "webmapclient_version=${i}" -t "${REPOSITORY}/${IMAGENAME}:${i}" .
done

# create tag "latest" from last position in versions array
lastelem=${versions[$((${#versions[@]}-1))]}
docker build --build-arg "citydb_version=${lastelem}" -t "${REPOSITORY}/${IMAGENAME}:latest" .
