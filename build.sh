#!/usr/bin/env bash

docker build --no-cache -f Dockerfile -t ark-server:$(date +%Y-%m-%d) .
