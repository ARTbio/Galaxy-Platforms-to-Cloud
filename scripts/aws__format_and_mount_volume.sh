#!/usr/bin/env bash
# as root

EXTRA_VOLUME=galaxy-data # adapt to the name of the GCE extra volume available on the web interface
# Be careful to point to the correct interface (here sdb with one extra volume)
DEVICE=/dev/xvdb

# see http://docs.aws.amazon.com/en_en/AWSEC2/latest/UserGuide/ebs-using-volumes.html for adding persistent disk to aws instances

# Format and attach an extra volume (ext4 formated) to the gce main instance
mkfs.ext4 -F -E lazy_itable_init=0,lazy_journal_init=0,discard $DEVICE
mkdir -p /mnt/$EXTRA_VOLUME
mount -o discard,defaults $DEVICE /mnt/$EXTRA_VOLUME
chmod a+w /mnt/$EXTRA_VOLUME

# to get persistent mounting
echo UUID=`sudo blkid -s UUID -o value $DEVICE` /mnt/$EXTRA_VOLUME ext4 discard,defaults,nobootwait 0 2 | sudo tee -a /etc/fstab

