#!/usr/bin/env bash

# This script needs the slurm-net network, which was created by running
#docker network create -d macvlan \
#    --subnet=192.168.2.0/24 \
#    --gateway=192.168.2.251 \
#    -o parent=virtual2 slurm-net

HOSTNAME=slurm-mp2013
IP=192.168.2.60
NET=slurm-net
docker run -d \
       --name slurm \
       --net "$NET" \
       --privileged \
       --add-host 'slurm-mp2013:192.168.2.60' \
       --add-host 'slurm-artimed:192.168.2.61' \
       --add-host 'slurm-plastisipi:192.168.2.63' \
       --add-host 'slurm-mississippi:192.168.2.64' \
       --add-host 'mississippi:192.168.2.254' \
       --add-host 'mississippi.snv.jussieu.fr:192.168.2.254' \
       --ip "$IP" \
       --hostname "$HOSTNAME" \
       -e "DOCKER_AUTOSTART=true" \
       -e "ADD_SLURM_USER_TO_DOCKER_GROUP=true" \
       -e "SLURMCTLD_AUTOSTART=false" \
       -e "GALAXY_DIR=/export/galaxy/" \
       -e "SYMLINK_TARGET=/home/galaxy" \
       -e "SLURM_UID=1002" \
       -e "SLURM_GID=1002" \
       -e "MUNGE_KEY_PATH=/export/galaxy/munge.key" \
       -e "SLURM_CONF_PATH=/export/galaxy/slurm.conf" \
       -v /home/galaxy/galaxy-slurm/galaxy-slurm-data/:/export \
       -v /home/galaxy/galaxy-slurm/galaxy-slurm-data/tmp:/var/storage/tmp \
       -v /home/galaxy/galaxy-slurm/galaxy-slurm-data/job_working_directory:/var/storage/job_working_directory \
       -v /home/galaxy/galaxy-slurm/galaxy-slurm-data/files:/var/storage/files \
       -v /home/galaxy/galaxy-slurm/galaxy-slurm-data/ftp:/var/storage/ftp \
       mvdbeek/galaxy-slurm
