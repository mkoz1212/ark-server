#!/usr/bin/env bash

source config.sh

# Install Steam (if necessary)
if [ ! -e "${HOST_STEAM_PATH}/steamcmd" ]; then
docker run -it --rm \
    --volume ${HOST_STEAM_PATH}:${GUEST_STEAM_PATH} \
    --name ArkServer-Setup \
    ark-server:latest \
    /bin/bash -c "mkdir steamcmd; curl -sqL 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar -C steamcmd -zxvf - && steamcmd/steamcmd.sh +quit"
fi

# Install ArkServer (or update)
docker run -it --rm \
    --volume ${HOST_STEAM_PATH}:${GUEST_STEAM_PATH} \
    --name ArkServer-Setup \
    ark-server:latest \
    /bin/bash -c "steamcmd/steamcmd.sh +force_install_dir /home/steam/ark +login anonymous +app_update 376030 +quit"


