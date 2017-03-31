#!/usr/bin/env bash
# as root

EXTRA_VOLUME=galaxy-data # adapt to the name of the GCE extra volume available on the web interface
# Be careful to point to the correct interface (here sdb with one extra volume)
DEVICE=/dev/sdb

# see https://cloud.google.com/compute/docs/disks/add-persistent-disk for adding persistent disk to gce instances

# Format and attach an extra volume (ext4 formated) to the gce main instance
mkfs.ext4 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/disk/by-id/google-$EXTRA_VOLUME
mkdir -p /mnt/disks/$EXTRA_VOLUME
mount -o discard,defaults /dev/disk/by-id/google-$EXTRA_VOLUME /mnt/disks/$EXTRA_VOLUME
chmod a+w /mnt/disks/$EXTRA_VOLUME
echo "$DEVICE /mnt/disks/$EXTRA_VOLUME ext4 defaults 0 0" | sudo tee -a /etc/fstab # to get persistent mounting
apt-get update 
apt-get install -y git
apt-get install -y software-properties-common
apt-add-repository -y ppa:ansible/ansible
apt-get update
apt-get install -y ansible
git clone https://github.com/ARTbio/GalaxyKickStart.git
cd GalaxyKickStart
ansible-galaxy install -r requirements_roles.yml -p roles

# change /export to /mnt/disks/$EXTRA_VOLUME in group_vars/all
sed -i "s/\/export #/\/mnt\/disks\/$EXTRA_VOLUME #/" group_vars/all

ansible-playbook -i inventory_files/galaxy-kickstart galaxy.yml
