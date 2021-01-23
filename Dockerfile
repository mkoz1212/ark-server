FROM ubuntu:20.04

MAINTAINER mickoz84
LABEL maintainer="mickoz84"

RUN DEBIAN_FRONTEND=noninteractive apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y libc6-i386 lib32gcc1 curl wget locales && \
    locale-gen en_US.UTF-8 && update-locale && \
    rm -rf /var/lib/apt/lists/*

ENV LANG en_US.UTF-8
ENV LANGUAGE en

RUN adduser --disabled-login --shell /bin/bash --gecos "" steam 

USER steam
WORKDIR /home/steam/

RUN mkdir steamcmd && \
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar -C steamcmd -zxvf - && \
    steamcmd/steamcmd.sh +quit

WORKDIR /ark

