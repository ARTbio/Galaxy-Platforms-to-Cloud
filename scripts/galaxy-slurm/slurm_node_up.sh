#!/usr/bin/env bash

# execute as root after the script "restart_GKS_slurm-master-node.sh"

# adapt the IP_MASTER accordingly (Master node IP)
IP_MASTER=10.132.0.4 

mount -t nfs4 -o proto=tcp,port=2049 $IP_MASTER:/galaxy/ /home/galaxy/
nohup /usr/sbin/munged --key-file=/home/galaxy/munge.key -F --force &
sleep 10
nohup /usr/sbin/slurmd -f /home/galaxy/slurm.conf -D -L /home/galaxy/galaxy/slurmd.log &
echo "munge and slurmd launched, shared galaxy mounted !\n"
