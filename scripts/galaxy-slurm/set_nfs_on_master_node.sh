#!/usr/bin/env bash
# execute as root on the master slurm node

apt-get update
apt-get install -y nfs-kernel-server nfs-common
mkdir /nfs_export
cd /nfs_export
mkdir files ftp galaxy job_working_directory tmp
chown galaxy:galaxy files ftp galaxy job_working_directory tmp
chmod o+w+t files ftp galaxy job_working_directory tmp
chmod 755 galaxy
chmod -t galaxy
echo "# exports for slurm" | tee -a /etc/fstab
echo "/home/galaxy /nfs_export/galaxy none bind" | tee -a /etc/fstab
echo "/home/galaxy/galaxy/database/jobs /nfs_export/job_working_directory none bind" | tee -a /etc/fstab
echo "/home/galaxy/galaxy/database/tmp /nfs_export/tmp none bind" | tee -a /etc/fstab
echo "/home/galaxy/galaxy/database/datasets /nfs_export/files none bind" | tee -a /etc/fstab
echo "/home/galaxy/galaxy/database/ftp /nfs_export/ftp none bind" | tee -a /etc/fstab

echo "/nfs_export 10.132.0.0/24(rw,fsid=0,no_subtree_check)" | tee -a /etc/exports
echo "/nfs_export/files 10.132.0.0/24(rw,nohide,insecure,no_subtree_check)" | tee -a /etc/exports
echo "/nfs_export/ftp 10.132.0.0/24(rw,nohide,insecure,no_subtree_check)" | tee -a /etc/nfs_exports
echo "/nfs_export/galaxy 10.132.0.0/24(rw,fsid=1,nohide,insecure,no_subtree_check,no_root_squash)" | tee -a /etc/exports
echo "/nfs_export/job_working_directory 10.132.0.0/24(rw,nohide,insecure,no_subtree_check)" | tee -a /etc/exports
echo "/nfs_export/tmp 10.132.0.0/24(rw,nohide,insecure,no_subtree_check)" | tee -a /etc/exports
