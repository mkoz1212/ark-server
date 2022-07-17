FROM ubuntu:20.04

MAINTAINER mickoz84
LABEL maintainer="mickoz84"

# Install dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y libc6-i386 lib32gcc1 curl wget locales && \
    locale-gen en_US.UTF-8 && update-locale && \
    rm -rf /var/lib/apt/lists/*

# Set env variables
ENV LANG en_US.UTF-8
ENV LANGUAGE en

# Create steam user
RUN adduser --disabled-login --shell /bin/bash --gecos "" steam 
USER steam
WORKDIR /home/steam/

