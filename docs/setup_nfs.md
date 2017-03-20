# Set Up a simple NFS for the virtual cluster

## On slurmd & slurmctld control node side (ie GalaxyKickStart instance)

- Edit* and Run as root the script [set_nfs_on_master_node.sh](https://github.com/ARTbio/PtC/blob/master/scripts/galaxy-slurm/set_nfs_on_master_node.sh) that will
    - install and run `nfs-kernel-server` and `nfs-common` packages.
    - create `/nfs_export` and `/nfs_export/galaxy` directories (for bind mounts of /home/galaxy and other file system bind mounted within /home/galaxy)
    - change the `/etc/fstab` file for making permanent the bind mounts
    - modify the `/etc/exports` file for appropriate sharing
    - restart NFS server ( `sudo /etc/init.d/nfs-kernel-server restart`)
    - *Be aware that the current scenario is played after GKS galaxy install and export of permanent Galaxy data on an extra mounted volume (see the `$GKS_EXPORT_DIR` variable in the script). The `$IP_RANGE` should also been edited before running the script, according to your slurm network
    - Be aware that GKS modified the `/etc/fstab` file prior this script is permanent data was chosen to be exported on permanent or snapshotable volume. 

## On slurmd slave nodes sides

- Edit and run as root the script [](https://github.com/ARTbio/Galaxy-Platforms-to-Cloud/blob/master/scripts/galaxy-slurm/slurm_node_up.sh) that will:

- `apt-get install nfs-common`
- create the galaxy 1450:100 user, as well as the mounting point for shared nfs volume (`/home/galaxy`). *Still to be scripted.*
- mount the shared /home/galaxy volume as well as its bind mounted sub file systems. see the [slurm_node_up.sh](https://github.com/ARTbio/Galaxy-Platforms-to-Cloud/blob/master/scripts/galaxy-slurm/slurm_node_up.sh) script.

