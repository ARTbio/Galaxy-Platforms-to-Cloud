#!/usr/bin/env bash

# change /usr/sbin/configure_slurm.py
# to get something such as:

# NodeName=$hostname CPUs=$cpus RealMemory=$memory State=UNKNOWN # this is coded from origin
# NodeName=mississippi-node-1 CPUs=$cpus RealMemory=$memory State=UNKNOWN # ^^^adapt
# NodeName=mississippi-node-x CPUs=$cpus RealMemory=$memory State=UNKNOWN # ^^^adapt
# PartitionName=$partition_name Nodes=$hostname,mississippi-node-1 Default=YES MaxTime=INFINITE State=UP Shared=YES
#                                              ^^^^^^^^^^^^^^^^^^^
#                                                     adapt

supervisorct restart slurmctld slurmd
