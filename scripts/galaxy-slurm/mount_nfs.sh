#!/usr/bin/env bash
sudo mount -t nfs4 -o proto=tcp,port=2049 10.132.0.2:/ /home/galaxy/galaxy-slurm/galaxy-slurm-data

