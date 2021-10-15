HOST_ARK_PATH="/home/mkoz/steam/ark"
GUEST_ARK_PATH="/ark"

function check_port {
    netstat -tulp 2>/dev/null | grep ":${1}\b" > /dev/null
    echo $((1 - $?))
}

function find_port {
    PORT=$1
    while [ $(check_port $PORT) -ne 0 ]; do
        PORT=$((PORT+2))
    done
    echo $PORT
}

#PORT=$(find_port 7777)

function default_port {
    MAP=$1
    case $MAP in 
        TheIsland) 
            port=7777
            ;;
        ScorchedEarth_P) 
            port=7779
            ;;
        Aberration_P) 
            port=7781
            ;;
        Extinction)
            port=7783
            ;;
        Genesis) 
            port=7785
            ;;
        Gen2) 
            port=7787
            ;;
        TheCenter) 
            port=7789
            ;;
        Ragnarok) 
            port=7791
            ;;
        Valguero_P) 
            port=7793
            ;;
        CrystalIsles) 
            port=7795
            ;;
        *) 
            echo "Unknown MAP: $MAP"
            exit 1
    esac
    echo $port
}

PORT=$(default_port $MAP)
