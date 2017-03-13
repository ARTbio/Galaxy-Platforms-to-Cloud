# Testing the mvdbeek/galaxy-slurm docker container

available in [Docker Registry](https://hub.docker.com/r/mvdbeek/galaxy-slurm/)


## set up a docker network with master and slave nodes

the script net.sh:



### node 0
```
#!/usr/bin/env bash
docker network create -d macvlan \
    --subnet=192.168.2.0/24 \
    --gateway=192.168.2.123  \ # this value on the node 0 should be clarified
    -o parent=eth0 slurm-net    
```
### node 1
```
docker network create -d macvlan \
    --subnet=192.168.2.0/24 \
    --gateway=192.168.2.251  \
    -o parent=eth0 slurm-net
```


## Install scripts in the /home/galaxy/galaxy-slurm folder



### slurm.conf

Edit `/etc/slurm-llnl/slurm.conf`

and add:
```
NodeName=mississippi-node-0 CPUs=2 RealMemory=7479 State=UNKNOWN
NodeName=mississippi-node-1 CPUs=2 RealMemory=7479 State=UNKNOWN
PartitionName=debug Nodes=mississippi-node-0,mississippi-node-1 Default=YES MaxTime=INFINITE State=UP Shared=YES
```

and

copy: `cp /etc/slurm-llnl/slurm.conf /home/galaxy/galaxy/`

and see the new nfs export and mount in /etc/fstab

