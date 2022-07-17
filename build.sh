#!/usr/bin/env bash
set -e

source config.sh

# Build docker image
docker build \
    --no-cache \
    --file Dockerfile \
    --tag ark-server:$(date +%Y-%m-%d) \
    --tag ark-server:latest \
    .

