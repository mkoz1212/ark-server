#!/usr/bin/env bash
set -e

# Build a docker image for Ark Survival Evolved

source settings.cfg

BASE=${BASE:-ubuntu:22.04}

# Pull base image
docker pull ${BASE}

# Build docker image
docker build \
    --no-cache \
    --file Dockerfile \
    --build-arg BASE=${BASE} \
    --tag ark-server:$(date +%Y-%m-%d) \
    --tag ark-server:latest \
    .

