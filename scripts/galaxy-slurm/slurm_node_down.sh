#!/usr/bin/env bash

# execute as root.

killall slurmd munged
umount /home/galaxy/

echo "munge and slurmd killed, shared galaxy hopefully umounted !\n"
