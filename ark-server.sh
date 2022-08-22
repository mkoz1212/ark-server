#!/usr/bin/env bash

source settings.cfg
source setup_map.sh

# show help
USAGE="$(basename $0) mode [options] 
available modes:
 - install:  
    installs/updates steam and ark server in configured HOST_STEAM_PATH
 - start: 
    start ark server
 - stop:
    stop ark server (or all servers)
"
if [ "$1" == "-h" ] || [ "$1" == "--help" ] || [ $# -le 0 ]; then
    echo "$USAGE"
    exit 0
fi

# start - mode
function start_server {
    
    # Default map
    MAP="TheIsland"

    USAGE="$(basename $0) start map [-p/--port port] [-c/--cluster]"
    while [[ $# -gt 0 ]]; do
        case $1 in
            -p|--port)
                PORT="$2"
                shift; shift;
                ;;
            -c|--cluster)
                if [ -z "${CLUSTER_NAME}" ]; then
                    echo "Cluster not configured! Please add CLUSTER_NAME to settings.cfg" >&2
                    exit 1
                fi
                CLUSTER="${CLUSTER_NAME}"
                shift
                ;;
            -h|--help)
                echo "usage: $USAGE"
                exit 0
                ;;
            -*|--*)
                echo "Unknown option $1" >&2
                echo "usage: $USAGE" >&2
                exit 1
                ;;
            *)
                MAP=$1
                shift 
                ;;
        esac
    done

    # Setup map name and port
    setup_map ${MAP} ${PORT}

    # Set query port based on client port
    QUERY_PORT=$((27015+PORT-7777))

    # Set up game options
    GAME_OPTS="${MAP}?listen"
    if [ ! -z "${CLUSTER}" ]; then
        GAME_OPTS="${GAME_OPTS}?SessionName=${CLUSTER}_${MAP}"
        GAME_OPTS="${GAME_OPTS}?AltSaveDirectoryName=map_${CLUSTER}_${MAP}"
    else
        GAME_OPTS="${GAME_OPTS}?SessionName=${MAP}"
        GAME_OPTS="${GAME_OPTS}?AltSaveDirectoryName=map_single_${MAP}"
    fi
    GAME_OPTS="${GAME_OPTS}?Port=${PORT}"
    GAME_OPTS="${GAME_OPTS}?QueryPort=${QUERY_PORT}"
    GAME_OPTS="${GAME_OPTS}?MaxPlayers=${MAX_PLAYER}"
    GAME_OPTS="${GAME_OPTS}?DisableWeatherFog=true"

    # If modded map is used the MAP_MOD variable needs to be set
    if [ ! -z "${MAP_MOD}" ]; then 
        GAME_OPTS="${GAME_OPTS}?GameModIds=${MODS},${MAP_MOD}" 
    else
        GAME_OPTS="${GAME_OPTS}?GameModIds=${MODS}"
    fi

    # Set up game parameters
    GAME_PARAMS=""
    if [ ! -z "${CLUSTER}" ]; then
        GAME_PARAMS="${GAME_PARAMS} -clusterid=${CLUSTER}"
    fi

    # If EVENT variable is set use it as ActiveEvent parameter
    if [ ! -z "${EVENT}" ]; then 
        GAME_PARAMS="${GAME_PARAMS} -ActiveEvent=${EVENT}"
    fi

    GAME_PARAMS="${GAME_PARAMS} -NoBattlEye -noantispeedhack -exclusivejoin -ForceAllowCaveFlyers -NoTransferFromFiltering"
    GAME_PARAMS="${GAME_PARAMS} -automanagedmods -server -high -log"

    echo "-----------"
    echo "Starting ARK Server with map: $MAP_NAME ($MAP)"
    echo "Using port: $PORT"
    echo "Using query port: $QUERY_PORT"
    echo "-----------"
    CMD="/home/steam/ark/ShooterGame/Binaries/Linux/ShooterGameServer ${GAME_OPTS} ${GAME_PARAMS}"
    echo $CMD
    echo "-----------"

    docker run -d --rm \
        --volume ${HOST_STEAM_PATH}:/home/steam \
        -p ${PORT}:${PORT}/udp \
        -p $((PORT+1)):$((PORT+1))/udp \
        -p ${QUERY_PORT}:${QUERY_PORT}/udp \
        --ulimit nofile=1000000:1000000 \
        --workdir=/home/steam/ark/ShooterGame/Saved/Logs \
        --name ArkServer-${MAP_NAME} \
        ark-server:latest ${CMD}
}


# stop mode
function stop_server {
    
    TIMEOUT=180
    STOP_ALL=0
    USAGE="$(basename $0) stop [map] [-a/--all]"

    MAPS=()
    while [[ $# -gt 0 ]]; do
        case $1 in
            -a|--all)
                STOP_ALL=1
                shift
                ;;
            -h|--help)
                echo "usage: $USAGE"
                exit 0
                ;;
            -*|--*)
                echo "unknown option $1" >&2
                echo "usage: $USAGE" >&2
                exit 1
                ;;
            *)
                MAPS+=("$1")
                shift 
                ;;
        esac
    done
    CONTAINERS=$(docker ps --filter "name=ArkServer" --format "{{.Names}}")

    for container in ${CONTAINERS}; do
        if [ $STOP_ALL -eq 1 ]; then
            docker stop --time ${TIMEOUT} ${container}
            continue
        fi
        for map in "${MAPS[@]}"; do
            if [ "$container" == "$map" ] || [ "$container" == "ArkServer-$map" ]; then
                docker stop --time ${TIMEOUT} ${container}
                continue
            fi
        done
    done
}


function install_server {

    # Install Steam (if necessary)
    if [ ! -e "${HOST_STEAM_PATH}/steamcmd" ]; then
    docker run -it --rm \
        --volume ${HOST_STEAM_PATH}:/home/steam \
        --name ArkServer-Setup \
        ark-server:latest \
        /bin/bash -c "mkdir steamcmd; curl -sqL 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar -C steamcmd -zxvf - && steamcmd/steamcmd.sh +quit"
    fi

    # Install (or update) ArkServer
    docker run -it --rm \
        --volume ${HOST_STEAM_PATH}:/home/steam \
        --name ArkServer-Setup \
        ark-server:latest \
        /bin/bash -c "steamcmd/steamcmd.sh +force_install_dir /home/steam/ark +login anonymous +app_update 376030 +quit"
}


# check mode
case $1 in
    install)
        shift;
        install_server $@
        ;;
    start)
        shift;
        start_server $@
        ;;
    stop)
        shift;
        stop_server $@
        ;;
    *)
        echo "Mode '$1' unknown, usage:"
        echo $USAGE
        exit 1
esac

exit 0



