Ark SE - Docker Server Setup
============================

Collection of tools to run a Ark Survival Evolved server under Linux in a docker container.



### Build docker

1. Setup docker (see https://docs.docker.com/get-docker/)

2. Run `./build_docker.sh`

The docker image is basically a Ubuntu image with a few additional packages and a steam user.


### Install Server

The ark server and steam will be install in the local folder `HOST_STEAM_PATH` which can be
configured in `settings.cfg`.
To install server run:

```bash
./ark-server install
```

The same command can be used to update the server later.


### Start a server

To start an ark server with the map `TheIsland` run:

```bash
./ark-server start TheIsland
```

To start a cluster server run:

```bash
./ark-server start --cluster TheIsland
```


### Stop server

To stop an ark server you can either individually stop them by map:

```bash
./ark-server stop TheIsland
```

Or stop all running server:

```bash
./ark-server stop --all
```


### Notes

*  make sure to port forward all used port in your router
