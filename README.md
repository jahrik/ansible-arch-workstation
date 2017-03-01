# Arch linux install with ansible provisioning

This tool is meant to be used with arch linux after a base installation has been performed.

Ansible will be installed after the base install to double-check our work and handle the rest.



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

First go to [archlinux downloads](https://www.archlinux.org/download/) and download the latest .iso file.

Burn it to a cd or memory stick.

```
dd bs=4M if=~/Downloads/archlinuxinstall.iso of=/dev/sdb && sync
```

### dm-crypt wipe on an empty disk or partition

[Dm-crypt Drive_preparation](https://wiki.archlinux.org/index.php/Dm-crypt/Drive_preparation)

Boot up into the live arch linux environment and wipe your drives. 

First, create a temporary encrypted container on the partition (sdXY) or the full disk (sdX) to be encrypted, 
e.g. using default encryption parameters and a random key via the --key-file /dev/{u}random option
```
cryptsetup open --type plain /dev/sdXY container --key-file /dev/random
```

Second, check it exists:
```
fdisk -l
Disk /dev/mapper/container: 1000 MB, 1000277504 bytes
```

Wipe the container with zeros. A use of if=/dev/urandom is not required as the encryption cipher is used for randomness.
```
dd if=/dev/zero of=/dev/mapper/container bs=1M status=progress
```

Finally, close the temporary container:
```
cryptsetup close container
```

### LVM on LUKS

[LVM_on_LUKS](https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#LVM_on_LUKS)
```
# partitions for /boot and /(encrypted drive)
parted -s /dev/sda mklabel msdos
parted -s -a optimal /dev/sda mkpart primary 0% 512MB
parted -s -a optimal /dev/sda mkpart primary 512MB 100%

# encrypt
cryptsetup luksFormat /dev/sda2
# password: # *use yubikey for 2FA*

# open encrypted drive
cryptsetup open /dev/sda2 cryptolvm
# password: # *use yubikey for 2FA*
```

### partitioning.sh

```
wget https://raw.githubusercontent.com/jahrik/ansible-arch-workstation/master/partitioning.sh
```


### LVM
```
# create volume group
pvcreate /dev/mapper/cryptolvm
vgcreate vg /dev/mapper/cryptolvm

# create logical volumes
lvcreate -L 8G vg -n swap
lvcreate -L 100G vg -n root
lvcreate -L 100G vg -n var
lvcreate -l 100%FREE vg -n home
```

#### Format the partitions
```
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/mapper/vg-root
mkfs.ext4 /dev/mapper/vg-var
mkfs.ext4 /dev/mapper/vg-home
mkswap /dev/mapper/vg-swap
```

#### Mount file systems
```
mount /dev/mapper/vg-root /mnt
mkdir /mnt/home
mount /dev/mapper/vg-home /mnt/home
mkdir /mnt/var
mount /dev/mapper/vg-var /mnt/var
swapon /dev/mapper/vg-swap
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
```

#### Install the base system:
```
pacstrap /mnt base base-devel
```

#### Generate an fstab: 
```
genfstab -U -p /mnt >> /mnt/etc/fstab
```
 
Check to see it was written.
```
cat /mnt/etc/fstab
```

#### Chroot
```
arch-chroot /mnt /bin/bash
```

#### Install vim
```
pacman -S vim
```

#### Networking
```
pacman -S iw wpa_supplicant dialog
```

#### Root password
```
# first change root password
passwd
```

#### Configuring mkinitcpio
Edit /etc/mkinitcpio.conf and add the word "encrypt" and "lvm2" to HOOKS='...' just before "filesystems"
```
...
HOOKS="base udev autodetect modconf keyboard encrypt lvm2 block filesystems fsck"
...
```

Then run the command
```
mkinitcpio -p linux
```

#### Bootloader
[Boot_loader](https://wiki.archlinux.org/index.php/Dm-crypt/System_configuration#Boot_loader)
```
pacman -S grub

```

Edit /etc/default/grub
```
GRUB_CMDLINE_LINUX="cryptdevice=/dev/sda2:vg root=/dev/mapper/vg-root"
```

Configure grub
```
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
```

#### User
```
pacman -S zsh
groupadd <user>
useradd -m -g <user> -s /bin/zsh <user>
```

#### Sudo
```
pacman -S sudo

```

Add user to /etc/sudoers.d/config
```
<user> ALL=(ALL) NOPASSWD: ALL
```

## Ansible

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
