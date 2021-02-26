#!/usr/bin/env bash

source config.sh

MAP=${1:-TheIsland}
PORT=${2:-7777}
QUERY_PORT=$((27015+PORT-7777))
CLUSTER=mickoz84_cluster

function start_server {
    MAP=$1
    GAME_OPTS="${MAP}?listen"
    GAME_OPTS="${GAME_OPTS}?SessionName=${CLUSTER}_${MAP}"
    GAME_OPTS="${GAME_OPTS}?AltSaveDirectoryName=${CLUSTER}_${MAP}"
    #GAME_OPTS="${GAME_OPTS}?ServerPassword=bert1234"
    #GAME_OPTS="${GAME_OPTS}?ServerAdminPassword=damian1705"
    GAME_OPTS="${GAME_OPTS}?MaxPlayers=8"
    GAME_OPTS="${GAME_OPTS}?Port=${PORT}"
    GAME_OPTS="${GAME_OPTS}?QueryPort=${QUERY_PORT}"
    GAME_OPTS="${GAME_OPTS}?DisableWeatherFog=true"

    GAME_PARAMS="-clusterid=${CLUSTER}"
    GAME_PARAMS="${GAME_PARAMS} -NoBattleEye"
    GAME_PARAMS="${GAME_PARAMS} -noantispeedhack"
    GAME_PARAMS="${GAME_PARAMS} -exclusivejoin"
    GAME_PARAMS="${GAME_PARAMS} -ForceAllowCaveFlyers"
#    GAME_PARAMS="${GAME_PARAMS} -ActiveEvent=vday"
    GAME_PARAMS="${GAME_PARAMS} -server -high -log"

    echo "Starting ARK Server with map: $MAP"
    echo "Using port: $PORT"
    echo "Using query port: $QUERY_PORT"
    echo "GAME_OPTS:"
    echo $GAME_OPTS
    echo "GAME_PARAMS:"
    echo $GAME_PARAMS

    docker run -d --rm \
        --volume ${HOST_ARK_PATH}:${GUEST_ARK_PATH} \
        --name ArkServer-${MAP} \
        --network host \
        --ulimit nofile=1000000:1000000 \
        --workdir="/ark/ShooterGame/Saved/Logs" \
        ark-server:latest \
        /ark/ShooterGame/Binaries/Linux/ShooterGameServer ${GAME_OPTS} ${GAME_PARAMS}
}

start_server $MAP

