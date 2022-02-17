# Arch Workstation

[![CICD](https://github.com/jahrik/ansible-arch-workstation/actions/workflows/cicd.yml/badge.svg)](https://github.com/jahrik/ansible-arch-workstation/actions/workflows/cicd.yml)

Setup an Arch Linux development environment

<!-- vim-markdown-toc GFM -->

* [Requirements](#requirements)
* [Role Variables](#role-variables)
* [Dependencies](#dependencies)
* [Example Playbook](#example-playbook)
* [License](#license)
* [Notes](#notes)
  * [Initial installation](#initial-installation)
  * [Parted](#parted)
  * [LVM](#lvm)
  * [Formatting](#formatting)
  * [Mounting](#mounting)
  * [WiFi](#wifi)
  * [Arch Install](#arch-install)
  * [Ansible](#ansible)
  * [Vagrant lab](#vagrant-lab)

<!-- vim-markdown-toc -->

## Requirements

This role is intended for setting a development environment on fresh install of Arch Linux. It is a collection of roles that install things like i3-gaps, vim, and zsh. 

## Role Variables

    time_zone: US/Pacific
    locale: en_US.UTF-8 UTF-8

    # base packages
    base:
      - git
      - sudo

    # ZSH Configs
    theme: robbyrussell
    # Set default $EDITOR
    editor: vim
    # Set default $BROWSER
    browser: chromium
    lang: en_US.UTF-8
    # Set your default $TERM
    term: rxvt
    # Include things to your $PATH
    path:
      - ~/bin
    # zsh plugins
    plugins:
      - sudo
      - git

    # i3 configs
    text:
      font: DejaVu Sans Mono
      size: 18
    i3:
      lock: true
      # Conky i3 bar or polybar
      bar: false
      polybar: true

    # Python/Ansible color output
    python_force_color: 1
    ansible_force_color: 1

    vagrant_plugins:
      # - vagrant-hostsupdater
      # - vagrant-share
      # - vagrant-vbguest

## Dependencies

- jahrik.zsh
- jahrik.vim
- jahrik.i3_gaps

## Example Playbook

    - hosts: localhost
      roles:
         - { role: jahrik.arch_workstation, x: 42 }

## License

GPLv2

## Notes

This repository is the first thing I clone any time I reinstall Arch on a new laptop to get it back up and running with i3-gaps, vim, zsh, and a few other tools I use every time. Arch has some of the best documentation around and their installation guide has everything needed to get a new machine up and running. I won't go into too much detail about the basic installation process other than some handy notes for myself later.

### Initial installation

[Installation Guide](https://wiki.archlinux.org/title/installation_guide)

### Parted

    parted -s /dev/sda mklabel msdos
    # /boot
    parted -s -a optimal /dev/sda mkpart primary 0% 1G
    # swap
    parted -s -a optimal /dev/sda mkpart primary 1G 9G
    # /
    parted -s -a optimal /dev/sda mkpart primary 9G 100%

### LVM

    # create volume group
    pvcreate /dev/sdaX
    vgcreate vg /dev/sdaX

    # create logical volumes
    lvcreate -L 8G vg -n swap
    lvcreate -L 100G vg -n root
    lvcreate -L 100G vg -n var
    lvcreate -l 100%FREE vg -n home

### Formatting

    mkfs.ext4 /dev/sdaX
    mkfs.ext4 /dev/mapper/vg-root
    mkfs.ext4 /dev/mapper/vg-var
    mkfs.ext4 /dev/mapper/vg-home
    mkswap /dev/mapper/vg-swap

### Mounting

    mount /dev/mapper/vg-root /mnt
    mkdir /mnt/home
    mount /dev/mapper/vg-home /mnt/home
    mkdir /mnt/var
    mount /dev/mapper/vg-var /mnt/var
    swapon /dev/mapper/vg-swap
    mkdir /mnt/boot
    mount /dev/sda1 /mnt/boot

### WiFi

    iwctl
    station list
    station wlan0 scan
    statoin wlan0 get-networks
    station wlan0 connect <NETWORK>

### Arch Install

Once you've got the basics down, like connecting to WiFi, handling any disk formatting, and having everything mounted to /mnt, you have a couple options. Use the archinstall script, or keep following the installation guide linked above.

[archinstall](https://github.com/archlinux/archinstall)

### Ansible

Install Git and Ansible

    pacman -S git ansible

Clone this repo

    git clone https://github.com/jahrik/ansible-arch-workstation.git

Install dependencies from [Ansible Galaxy](https://galaxy.ansible.com/)

    ansible-galaxy install -r requirements.yml

Run Ansible against localhost

    ansible-playbook -l local playbook.yml

### Vagrant lab

Use vagrant to spin up a virtual machine for testing things like i3 and GUI stuff.

Install Vagrant and it's dependencies

```
pacman -S vagrant virtualbox
```

Bring up an arch box

    vagrant up

Check the status of vagrant

    vagrant status

    rurrent machine states:

    arch-vm              running (virtualbox)

SSH into the box

    vagrant ssh arch-vm.dev


Run the playbook against the vm

    ansible-playbook -i inventory.yml -l vagrant playbook.yml -K
