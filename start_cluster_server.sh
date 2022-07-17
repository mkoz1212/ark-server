#!/usr/bin/env bash

MAP=${1:-TheIsland}
CLUSTER=mickoz84_cluster

source config.sh
source config_map.sh

PORT=${2:-$PORT}
QUERY_PORT=$((27015+PORT-7777))

GAME_OPTS="${MAP}?listen"
GAME_OPTS="${GAME_OPTS}?SessionName=${CLUSTER}_${MAP}"
GAME_OPTS="${GAME_OPTS}?AltSaveDirectoryName=${CLUSTER}_${MAP}"
#GAME_OPTS="${GAME_OPTS}?ServerPassword="
#GAME_OPTS="${GAME_OPTS}?ServerAdminPassword="
GAME_OPTS="${GAME_OPTS}?MaxPlayers=8"
GAME_OPTS="${GAME_OPTS}?Port=${PORT}"
GAME_OPTS="${GAME_OPTS}?QueryPort=${QUERY_PORT}"
GAME_OPTS="${GAME_OPTS}?DisableWeatherFog=true"

GAME_OPTS="${GAME_OPTS}?GameModIds=731604991,2307661303,924933745,1609138312,751991809"
if [ "${MAP_MOD}" != "" ]; then GAME_OPTS=${GAME_OPTS},${MAP_MOD}; fi

GAME_PARAMS="-clusterid=${CLUSTER}"
GAME_PARAMS="${GAME_PARAMS} -NoBattlEye"
GAME_PARAMS="${GAME_PARAMS} -noantispeedhack"
GAME_PARAMS="${GAME_PARAMS} -exclusivejoin"
GAME_PARAMS="${GAME_PARAMS} -ForceAllowCaveFlyers"
GAME_PARAMS="${GAME_PARAMS} -NoTransferFromFiltering"
#GAME_PARAMS="${GAME_PARAMS} -ActiveEvent=vday"
#GAME_PARAMS="${GAME_PARAMS} -ActiveEvent=Easter"
#GAME_PARAMS="${GAME_PARAMS} -ActiveEvent=Summer"
#GAME_PARAMS="${GAME_PARAMS} -ActiveEvent=FearEvolved"
#GAME_PARAMS="${GAME_PARAMS} -ActiveEvent=TurkeyTrial"
#GAME_PARAMS="${GAME_PARAMS} -ActiveEvent=WinterWonderland"
GAME_PARAMS="${GAME_PARAMS} -automanagedmods"
GAME_PARAMS="${GAME_PARAMS} -server -high -log"

echo "-----------"
echo "Starting ARK Server with map: $MAP_NAME ($MAP)"
echo "Using port: $PORT"
echo "Using query port: $QUERY_PORT"
echo "-----------"
CMD="${GUEST_STEAM_PATH}/ark/ShooterGame/Binaries/Linux/ShooterGameServer ${GAME_OPTS} ${GAME_PARAMS}"
echo "CMD = $CMD"
echo "-----------"

docker run -d --rm \
    --volume ${HOST_STEAM_PATH}:${GUEST_STEAM_PATH} \
    --network host \
    --ulimit nofile=1000000:1000000 \
    --workdir=${GUEST_STEAM_PATH}/ark/ShooterGame/Saved/Logs \
    --name ArkServer-${MAP_NAME} \
    ark-server:latest ${CMD}

