#!/usr/bin/env bash
# as root !

# first attach an extra volume (ext4 formated) to the gce main instance
mkdir -p /mnt/disks/galaxy-data
mount -o discard,defaults /dev/disk/by-id/google-galaxy-data /mnt/disks/galaxy-data
chmod a+w /mnt/disks/galaxy-data
echo "/dev/sdb /mnt/disks/galaxy-data ext4 defaults 0 0" | sudo tee -a /etc/fstab # to get persistent mounting
apt-get update 
apt-get install -y git
apt-get install -y software-properties-common
apt-add-repository -y ppa:ansible/ansible
apt-get update
apt-get install -y ansible
git clone https://github.com/ARTbio/GalaxyKickStart.git
cd GalaxyKickStart
ansible-galaxy install -r requirements_roles.yml -p roles

#
# manually edit ~/GalaxyKickStart/group_vars/all to change /export to /mnt/disks/galaxy-data
#

ansible-playbook -i inventory_files/galaxy-kickstart galaxy.yml
