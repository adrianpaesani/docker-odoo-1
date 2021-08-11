#!/bin/bash
DOCKER_REPO=rubeto
OVER=14
OREL=$(date '+%Y%m%d')
OSHA=$(git ls-remote https://github.com/odoo/odoo.git refs/heads/${OVER}.0-numa | cut -f 1)
time docker build --no-cache=true \
    --build-arg OVER=${OVER} \
    --build-arg OREL=${OREL} \
    --build-arg OSHA=${OSHA} \
    -t ${DOCKER_REPO}/odoo${OVER}usa:${OREL} -f ./build/DockerfileUSA ./build 2>&1 | tee -a build-odoo${OVER}usa-${OREL}.log
