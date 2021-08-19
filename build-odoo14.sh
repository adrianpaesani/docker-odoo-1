#!/bin/bash
DOCKER_REPO=rubeto
OVER=14
OREL=$(date '+%Y%m%d')
time docker build --no-cache=true \
    --build-arg OVER=${OVER} \
    --build-arg OREL=${OREL} \
    -t ${DOCKER_REPO}/odoo${OVER}:${OREL} -f ./build/Dockerfile ./build 2>&1 | tee -a build-odoo${OVER}-${OREL}.log
