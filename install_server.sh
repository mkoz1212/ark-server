#!/usr/bin/env bash

source config.sh

docker run -it --rm \
    --volume ${HOST_ARK_PATH}:${GUEST_ARK_PATH} \
    --name ArkServer-Setup \
    ark-server:latest \
    /bin/bash -c "/home/steam/steamcmd/steamcmd.sh +login anonymous +force_install_dir /ark +app_update 376030 +quit"
