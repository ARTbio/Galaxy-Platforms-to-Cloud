#!/usr/bin/env bash
docker network create -d macvlan \
    --subnet=10.132.0.0/24 \
    --gateway=10.132.0.1  \
    -o parent=virtual2 slurm-net
