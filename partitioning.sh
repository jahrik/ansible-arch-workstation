#!/bin/bash

# create volume group
pvcreate /dev/mapper/cryptolvm
vgcreate vg /dev/mapper/cryptolvm

# create logical volumes
lvcreate -L 8G vg -n swap
lvcreate -L 100G vg -n root
lvcreate -L 100G vg -n var
lvcreate -l 100%FREE vg -n home

#Format the partitions
mkfs.ext2 /dev/sda1
mkfs.ext4 /dev/mapper/vg-root
mkfs.ext4 /dev/mapper/vg-var
mkfs.ext4 /dev/mapper/vg-home
mkswap /dev/mapper/vg-swap

#Mount file systems
mount /dev/mapper/vg-root /mnt
mkdir /mnt/home
mount /dev/mapper/vg-home /mnt/home
mkdir /mnt/var
mount /dev/mapper/vg-var /mnt/var
swapon /dev/mapper/vg-swap
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

#Install the base system:
#pacstrap /mnt base base-devel

#Generate an fstab:
#genfstab -U -p /mnt >> /mnt/etc/fstab

#Check to see it was written.
#cat /mnt/etc/fstab
