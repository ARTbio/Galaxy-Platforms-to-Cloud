#!/usr/bin/env bash
# execute as root on the master slurm node
# Note that this script is for nfs set up on a slurm cluster w/o docker
# After running GalaxyKickStart and persistent data
# (/export--> mounted on a persistent extra volume whose path has to be set)

apt-get update
apt-get install -y nfs-kernel-server nfs-common
mkdir /nfs_export
cd /nfs_export
mkdir galaxy
chown galaxy:galaxy galaxy
chmod o+w+t galaxy
chmod 755 galaxy
chmod -t galaxy
echo "# exports for slurm" | tee -a /etc/fstab
echo "/home/galaxy /nfs_export/galaxy none bind" | tee -a /etc/fstab
echo "/mnt/disks/galaxy-data/home/galaxy/tool_dependencies /nfs_export/galaxy/tool_dependencies none bind" | tee -a /etc/fstab
echo "/mnt/disks/galaxy-data/home/galaxy/shed_tools /nfs_export/galaxy/shed_tools none bind" | tee -a /etc/fstab
echo "/mnt/disks/galaxy-data/home/galaxy/galaxy/tool-data /nfs_export/galaxy/galaxy/tool-data none bind" | tee -a /etc/fstab
echo "/mnt/disks/galaxy-data/home/galaxy/galaxy/config /nfs_export/galaxy/galaxy/config none bind" | tee -a /etc/fstab
echo "/mnt/disks/galaxy-data//home/galaxy/galaxy/database /nfs_export/galaxy/galaxy/database none bind" | tee -a /etc/fstab


echo "/nfs_export 10.132.0.0/24(rw,fsid=0,no_subtree_check)" | tee -a /etc/exports
echo "/nfs_export/galaxy 10.132.0.0/24(rw,fsid=1,nohide,insecure,no_subtree_check,no_root_squash)" | tee -a /etc/exports

