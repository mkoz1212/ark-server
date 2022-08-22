ARG BASE=ubuntu:22.04
FROM ${BASE}

MAINTAINER mickoz84
LABEL maintainer="mickoz84"

# Install dependencies
RUN apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y libc6-i386 lib32gcc-s1 curl wget locales \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
    
# Set env variables
ENV LANG en_US.UTF-8

# Create steam user
RUN adduser --disabled-login --shell /bin/bash --gecos "" steam 
USER steam
WORKDIR /home/steam/

