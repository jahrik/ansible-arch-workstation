# Arch linux install with ansible provisioning

This tool is meant to be used with arch linux after a base installation has been performed.

Ansible will be installed after the base install to double-check our work and handle the rest.

Table of Contents
=================

   * [Arch linux install with ansible provisioning](#arch-linux-install-with-ansible-provisioning)
      * [TODO](#todo)
      * [Initial installation](#initial-installation)
         * [dd:](#dd)
         * [Partition the hard drive:](#partition-the-hard-drive)
         * [Format your partitions:](#format-your-partitions)
         * [Disk Encryption:](#disk-encryption)
         * [Mount the partitions:](#mount-the-partitions)
         * [Install the base system:](#install-the-base-system)
         * [Generate an fstab:](#generate-an-fstab)
         * [Configure your new install:](#configure-your-new-install)
         * [Finish encryption of home partiition:](#finish-encryption-of-home-partiition)
      * [Let ansible handle the rest](#let-ansible-handle-the-rest)
      * [Vagrant lab](#vagrant-lab)

## TODO

Setup for:
- ansible
- yaourt
- i3
- vim
- zsh
- ruby
- chef

## Initial installation

### dd:

First go to the Arch website and download the latest .iso file.

Burn it to a cd or memory stick.

Be careful when using the dd command. It can easily overwrite your hard drive if you type it wrong.

```
lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda      8:0    0 465.8G  0 disk
├─sda1   8:1    0   300M  0 part /boot
├─sda2   8:2    0    12G  0 part /swap
├─sda3   8:3    0    12G  0 part /root
└─sda4   8:3    0   100G  0 part /home
sdb      8:16   1   3.6G  0 disk
├─sdb1   8:17   1   996M  0 part
└─sdb2   8:18   1   2.3M  0 part
sr0     11:0    1  1024M  0 rom
```
  
My usb is sdb
```
dd bs=4M if=~/Downloads/archlinuxinstall.iso of=/dev/sdb && sync
```

Boot up into the live arch linux environment and wipe your drives. 

Find out which /dev/ is your harddrive.
```
fdisk -l
```
Wipe existing data from drive.

```
dd if=/dev/urandom of=/dev/sda bs=4096
```

### Partition the hard drive:

Partitioning of the hard drive can be done with tools available on the Arch live cd, but I recommend using gparted.

Gparted can be found on any live ubuntu cd.

If however you would like to use the tools available then you have a couple of choices.
- cgdisk
- fdisk
- parted

You'll want a seperate /boot partition for an ecrypted setup.

Create seperate / and /home partitions as well.

Also create a "/swap" space [calculate swap](http://lmgtfy.com/?q=calculating+swap)
```
parted 
parted -s /dev/sda mklabel msdos
parted -s -a optimal /dev/sda mkpart primary 0% 512MB
parted -s -a optimal /dev/sda mkpart primary 512MB 2GB
parted -s -a optimal /dev/sda mkpart primary 2GB 20GB
parted -s -a optimal /dev/sda mkpart primary 20GB 100%
```

### Format your partitions:

if you are encrypting your drive, you might end up with a partitioning scheme like the following:

Show your partition table.
```
parted -l
Number  Start   End     Size    Type     File system     Flags
 1      1049kB  512MB   511MB   primary
 2      512MB   2000MB  1488MB  primary
 3      2000MB  20.0GB  18.0GB  primary
 4      20.0GB  250GB   230GB   primary
```
  
ext4 formating
```
mkfs.ext4 /dev/sda1
mkswap /dev/sda2
```

### Disk Encryption:
```
cryptsetup
cryptsetup <OPTIONS> <action> <action-specific-options> <device> <dmname>
```

Example
```
--cipher, -c  aes-xts-plain64 aes-xts-plain64 The example uses the same cipher as the default: the AES-cipher with XTS.
--key-size, -s  256 512 By default a 256 bit key-size is used. Note however that XTS splits the supplied key in half. So to use AES-256 instead of AES-128 you would have to set the XTS key-size to 512.
--hash, -h  sha1  sha512  Hash algorithm used for PBKDF2. Due to this processing, SHA1 is considered adequate as of January 2014.
--iter-time, -i 1000  5000  Number of milliseconds to spend with PBKDF2 passphrase processing. Using a hash stronger than sha1 results in less iterations if iter-time is not increased.
--use-random  --use-urandom --use-random  /dev/urandom is used as randomness source for the (long-term) volume master key. Avoid generating an insecure master key if low on entropy. The last three options only affect the encryption of the master key and not the disk operations.
--verify-passphrase, -y Yes - Default only for luksFormat and luksAddKey. No need to type for Arch Linux with LUKS mode at the moment.
```

The options used in the example column result in the following: 

Example:
```
 cryptsetup -v --cipher aes-xts-plain64 --key-size 512 --hash sha512 --iter-time 5000 --use-random luksFormat <device>
```

Checking results can be done with: 
```
luxDump
cryptsetup luksDump /dev/<drive>
```

Set up root partition to unlock with a password.

Setup home partition to mount after reading the key file from /etc/luks-keys/home

Use a yubikey to increase the security of your password.

Be sure to use a capital "YES" when prompted.
```
cryptsetup
# The root partition is going to be /dev/sda3
cryptsetup --cipher aes-xts-plain64 --key-size 512 --hash sha512 --iter-time 5000 --use-random --verify-passphrase luksFormat /dev/sda3
```
 
Open it with
```
cryptsetup luksOpen /dev/sda3 root
```

Format the encrypted root partition
```
mkfs.ext4 /dev/mapper/root
```

### Mount the partitions:

Following the example partitioning scheme
```
mount /dev/mapper/root /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
swapon /dev/sda2
```

### Install the base system:
```
# Omit the -i to avoid being asked what to install
pacstrap -i /mnt base base-devel
```

### Generate an fstab: 
```
genfstab -U -p /mnt >> /mnt/etc/fstab
```
 
Check to see it was written.
```
cat /mnt/etc/fstab
```


### Configure your new install: 
```
arch-chroot /mnt /bin/bash
```

### Finish encryption of home partiition: 

Create a key 

```
mkdir -p /etc/luks-keys
dd bs=512 count=4 if=/dev/urandom of=/etc/luks-keys/home iflag=fullblock
```

Cryptsetup for home partition 
```
cryptsetup --cipher aes-xts-plain64 --key-size 512 --hash sha512 --iter-time 5000 --use-random -d /etc/luks-keys/home luksFormat /dev/sda4
```
  
Open it with
```
cryptsetup luksOpen -d /etc/luks-keys/home /dev/sda4 home
```
  
Format it
```
mkfs.ext4 /dev/mapper/home
```

Edit /etc/mkinitcpio.conf and add the word "encrypt" to HOOKS='...' just before "filesystems"
```
...
HOOKS="base udev autodetect modconf block encrypt filesystems keyboard fsck"
...
```

Then run the command
```
mkinitcpio -p linux
```

Edit /etc/crypttab
```
...
home    /dev/sda4   /etc/luks-keys/home
...
```

Get uuid from /dev/mapper/home 
```
blkid
...
/dev/mapper/home: UUID="ecfaa756-c05b-4653-b18f-fa491bc47c03" TYPE="ext4"
...
```

Add entry to /etc/fstab for /dev/mapper/home 
```
...
# /dev/mapper/home
UUID=ecfaa756-c05b-4653-b18f-fa491bc47c03   /home       ext4        rw,relatime,data=ordered    0 2
...
```

## Let ansible handle the rest

Stuff and things go here...

...

...

## Vagrant lab

Not working yet.  Need to build a new packer arch box for testing.

Testing locally for now...

Bring up an arch box

    vagrant up

Check the status of vagrant

    vagrant status
    Current machine states:

    arch-vm              running (virtualbox)

SSH into a box

    vagrant ssh arch-vm.dev


Run the playbook against the vm

    ansible-playbook site.yml
