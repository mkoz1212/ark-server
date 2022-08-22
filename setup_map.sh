
# Setup environment variables for map. This uses a fixed assignment of
# ports for each map. Please make sure all ports are accessible
function setup_map {

    MAP_NAME=${1}
    MAP_PORT=${2}
    
    case ${1} in 
        TheIsland*) 
            PORT=7777
            MAP=TheIsland
            ;;
        ScorchedEarth*) 
            PORT=7779
            MAP=ScorchedEarth_P
            ;;
        Aberration*) 
            PORT=7781
            MAP=Aberration_P
            ;;
        Extinction)
            PORT=7783
            MAP=Extinction
            ;;
        Genesis) 
            PORT=7785
            MAP=Genesis
            ;;
        Gen2|Genesis2) 
            PORT=7787
            MAP=Gen2
            ;;
        TheCenter) 
            PORT=7789
            MAP=TheCenter
            ;;
        Ragnarok) 
            PORT=7791
            MAP=Ragnarok
            ;;
        Valguero*) 
            PORT=7793
            MAP=Valguero_P
            ;;
        CrystalIsles) 
            PORT=7795
            MAP=CrystalIsles
            ;;
        Fjordur)
            PORT=7797
            MAP=Fjordur
            ;;
        LostIsland) 
            PORT=7799
            MAP=LostIsland
            ;;
        *) 
            echo "Unknown map name: $MAP_NAME"
            exit 1
    esac
    if [ ! -z "$MAP_PORT" ]; then
        PORT=$MAP_PORT
    fi
}
