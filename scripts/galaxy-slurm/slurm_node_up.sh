#!/usr/bin/env bash

# to do on master node
# ln /etc/slurm-llnl/slurm.conf /home/galaxy/slurm.conf
# ln /etc/munge/munge.key /home/galaxy/munge.key

#mount -t nfs4 -o proto=tcp,port=2049 10.132.0.4:/galaxy/ /home/galaxy/
nohup /usr/sbin/munged --key-file=/home/galaxy/munge.key -F --force &
sleep 10
nohup /usr/sbin/slurmd -f /home/galaxy/slurm.conf -D -L /home/galaxy/galaxy/slurmd.log &
echo "munge and slurmd launched, shared galaxy mounted !\n"
