# Set Up a simple NFS for the virtual cluster

## test on GCE with three instances

- Create an export directory at root. `mkdir /export`
Note that the /export directory will be filled by GalaxyKickStart if it is created before running ansible-playbook

- server machine has internal IP address 10.132.0.2
- client machines have internal IP addresses 10.132.0.3 and 10.132.0.4
- For server machine, `apt-get install nfs-kernel-server nfs-common`
- For client machine (to be set later) `apt-get install nfs-common`

### On server side (slurm control node)

- Edit* and Run as root the script [set_nfs_on_master_node.sh](https://github.com/ARTbio/PtC/blob/master/scripts/galaxy-slurm/set_nfs_on_master_node.sh) that will
    - install and run `nfs-kernel-server` and `nfs-common` packages.
    - create `/nfs_export` and `/nfs_export/galaxy` directories (for bind mounts of /home/galaxy and other file system bind mounted within /home/galaxy)
    - change the /etc/fstab file for making permanent the bind mounts
    - modify the /etc/exports file for appropriate sharing
    - *Be aware that the current scenario is played after GKS galaxy install and export of permanent Galaxy data on an extra mounted volume (see the $GKS_EXPORT_DIR variable in the script). The $IP_RANGE should also been edited before running the script, according to your slurm network
    - Be aware of the add-in in /etc/fstab file triggered by GKS
```
/export//home/galaxy/tool_dependencies /home/galaxy/tool_dependencies none bind 0 0
/export//home/galaxy/galaxy/../shed_tools /home/galaxy/galaxy/../shed_tools none bind 0 0
/export//home/galaxy/galaxy/tool-data /home/galaxy/galaxy/tool-data none bind 0 0
/export//home/galaxy/galaxy/config /home/galaxy/galaxy/config none bind 0 0
/export//home/galaxy/galaxy/database /home/galaxy/galaxy/database none bind 0 0
/export//etc/postgresql/9.3/main /etc/postgresql/9.3/main none bind 0 0
```

- for docker-slurm, manually add to /etc/fstab:
`/export/home/galaxy /home/galaxy none bind 0 0` (maybe not necessary if just playing with nfs sharing, `to be tested`; in any case, the mounting point /export/home/galaxy is created by GKG) 

- Be aware of the export mechanism triggered by GKG when it found an /export directory (move.data role executed when this directory is present on the system)
```
root@mississippi-node-0:~# ll /export/
total 36
drwxr-xr-x  8 root     root     4096 Mar  5 18:42 ./
drwxr-xr-x 24 root     root     4096 Mar  7 10:26 ../
drwxr-xr-x  3 postgres postgres 4096 Mar  5 18:30 etc/
-rw-r--r--  1 root     root      609 Mar  5 18:30 exported_dirs.yml
drwxr-xr-x  2 root     root     4096 Mar  5 18:42 files/
drwxr-xr-x  2 root     root     4096 Mar  5 18:42 ftp/
drwxr-xr-x  3 galaxy   galaxy   4096 Mar  5 18:30 home/
drwxr-xr-x  2 root     root     4096 Mar  5 18:42 job_working_directory/
drwxr-xr-x  2 root     root     4096 Mar  5 18:42 tmp/
```
Probably exports still need adaptation to take into account this hierarchy

- Start or restart the nfs server `sudo /etc/init.d/nfs-kernel-server restart`
- $ exportfs -a ? see whether this is required #####
- Probably need to have persistent iptables:
```
apt-get update && apt-get install iptables-persistent
```
And add the following chains to /etc/iptables/rules.v4
```
-A INPUT -p tcp -m multiport --dports 2049 -m state --state NEW,ESTABLISHED -j ACCEPT
-A OUTPUT -p tcp -m multiport --sports 2049 -m state --state NEW,ESTABLISHED -j ACCEPT
-A OUTPUT -p tcp -m multiport --dports 2049 -m state --state NEW,ESTABLISHED -j ACCEPT
```
This manipulation comes from below where a port 2049 is specified in the mounting. Test whether is would work otherwise (even without iptables)

### On client side
- `apt-get install nfs-common`
- create /galaxy/galaxy-slurm directory `mkdir -p /home/galaxy/galaxy-slurm/` (owner will be root)
- create the mounting point for shared nfs volume:
`mkdir /home/galaxy/galaxy-slurm/galaxy-slurm-data/`
- Add this line to /etc/fstab of client machines: 
`10.132.0.2:/export   /home/galaxy/galaxy-slurm/galaxy-slurm-data   nfs    user    0   0`
But apparently, even skipping nfs,noauto, the volume does not mount automatically at boot. Probably better to comment this line for the moment in fstab
- option manual mounting:
`sudo mount -t nfs4 -o proto=tcp,port=2049 10.132.0.2:/ /home/galaxy/galaxy-slurm/galaxy-slurm-data` (from the "/home/galaxy/galaxy-slurm/mount_nfs.sh" script


OK, this worked for the client 10.132.0.3, I test by repeating on 10.132.0.4

