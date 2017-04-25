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
