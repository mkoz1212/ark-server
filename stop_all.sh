#!/bin/bash

TIMEOUT=180
CONTAINERS=$(docker ps --filter "name=ArkServer" --format "{{.Names}}")

for container in ${CONTAINERS}; do 
    docker stop --time ${TIMEOUT} ${container}
done
