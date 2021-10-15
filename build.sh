#!/usr/bin/env bash
set -e

docker build --no-cache -f Dockerfile -t ark-server:$(date +%Y-%m-%d) .
docker tag ark-server:$(date +%Y-%m-%d) ark-server:latest
