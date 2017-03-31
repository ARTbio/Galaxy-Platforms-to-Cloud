#!/usr/bin/env bash

#############
## This script should be run after gce_warmup.sh that install supervisor, supervisorctl,
## supervisorctl,slurmctl and slurmd via GalaxyKickStart
#############

# execute as root on the master slurm node
# Note that this script is for nfs set up on a slurm cluster w/o docker
# After running GalaxyKickStart and persistent data
# (/export--> mounted on a persistent extra volume whose path has to be set)
# TODO: treat case where Galaxy permanent data are not exported

# set the following $IP_RANGE variable according to your slurm network
IP_RANGE=10.132.0.0/24
# set the following $GKS_EXPORT_DIR according to the export of Galaxy permanent data as set with GalaxyKickStart
GKS_EXPORT_DIR="/mnt/disks/galaxy-data"

apt-get update
apt-get install -y nfs-kernel-server nfs-common
mkdir -p /nfs_export/galaxy
chown galaxy:galaxy /nfs_export/galaxy
chmod 755 galaxy
mount --bind /home/galaxy /nfs_export/galaxy
mount --bind $GKS_EXPORT_DIR/home/galaxy/tool_dependencies /nfs_export/galaxy/tool_dependencies
mount --bind $GKS_EXPORT_DIR/home/galaxy/shed_tools /nfs_export/galaxy/shed_tools
mount --bind $GKS_EXPORT_DIR/home/galaxy/galaxy/tool-data /nfs_export/galaxy/galaxy/tool-data
mount --bind $GKS_EXPORT_DIR/home/galaxy/galaxy/config /nfs_export/galaxy/galaxy/config
mount --bind $GKS_EXPORT_DIR/home/galaxy/galaxy/database /nfs_export/galaxy/galaxy/database

# modify /etc/fstab to make permanent mounting at boot
echo "# exports for slurm" | tee -a /etc/fstab
echo "/home/galaxy /nfs_export/galaxy none bind" | tee -a /etc/fstab
echo "$GKS_EXPORT_DIR/home/galaxy/tool_dependencies /nfs_export/galaxy/tool_dependencies none bind" | tee -a /etc/fstab
echo "$GKS_EXPORT_DIR/home/galaxy/shed_tools /nfs_export/galaxy/shed_tools none bind" | tee -a /etc/fstab
echo "$GKS_EXPORT_DIR/home/galaxy/galaxy/tool-data /nfs_export/galaxy/galaxy/tool-data none bind" | tee -a /etc/fstab
echo "$GKS_EXPORT_DIR/home/galaxy/galaxy/config /nfs_export/galaxy/galaxy/config none bind" | tee -a /etc/fstab
echo "$GKS_EXPORT_DIR/home/galaxy/galaxy/database /nfs_export/galaxy/galaxy/database none bind" | tee -a /etc/fstab

# modify NFS setting and restart NFS server
echo "/nfs_export $IP_RANGE(rw,fsid=0,no_subtree_check,no_root_squash)" | tee -a /etc/exports
echo "/nfs_export/galaxy $IP_RANGE(rw,fsid=1,nohide,insecure,no_subtree_check,no_root_squash,crossmnt)" | tee -a /etc/exports
/etc/init.d/nfs-kernel-server restart

# As GalaxyKickStart did its job, we can hard link slurmd.conf and munge.key
ln /etc/slurm-llnl/slurm.conf /home/galaxy/slurm.conf
ln /etc/munge/munge.key /home/galaxy/munge.key
