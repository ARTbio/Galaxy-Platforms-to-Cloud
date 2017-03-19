#!/usr/bin/env bash

# This script requires the slurm-net docker network,
# which bridges a docker network to a physical network adapter (virtual2 in this case)
## # Macvlan  (-o macvlan_mode= Defaults to Bridge mode if not specified)
# docker network create -d macvlan \
#     --subnet=192.168.2.0/24 \
#     --gateway=192.168.2.253  \
#     -o parent=virtual2 slurm-net

HOSTNAME=slurm-plastisipi
IP=192.168.2.63
NET=slurm-net
docker run -d \
       --name slurm \
       --privileged \
       --net "$NET" \
       --add-host 'slurm-mp2013:192.168.2.60' \
       --add-host 'slurm-artimed:192.168.2.61' \
       --add-host 'slurm-plastisipi:192.168.2.63' \
       --add-host 'slurm-mississippi:192.168.2.64' \
       --add-host 'mississippi:192.168.2.254' \
       --add-host 'mississippi.snv.jussieu.fr:192.168.2.254' \
       --ip "$IP" \
       --hostname "$HOSTNAME" \
       -e "SLURMCTLD_AUTOSTART=false" \
       -e "ADD_SLURM_USER_TO_DOCKER_GROUP=true" \
       -e "DOCKER_AUTOSTART=true" \
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