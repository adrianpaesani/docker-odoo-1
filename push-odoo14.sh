#!/bin/bash
DOCKER_REPO=rubeto
OVER=14
OREL=$(date '+%Y%m%d')
time docker push ${DOCKER_REPO}/odoo${OVER}:${OREL}
