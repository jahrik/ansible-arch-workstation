# Arch Workstation

[![CICD](https://github.com/jahrik/ansible-arch-workstation/actions/workflows/cicd.yml/badge.svg)](https://github.com/jahrik/ansible-arch-workstation/actions/workflows/cicd.yml)
[![Ansible Galaxy](https://img.shields.io/badge/ansible--galaxy-jahrik.workstation-blue?logo=ansible)](https://galaxy.ansible.com/ui/standalone/roles/jahrik/workstation/)

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

This role is intended for setting a development environment on fresh install of Arch Linux. It is a collection of roles that install things like i3-gaps, nvim, and zsh.

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
    editor: nvim
    # Set default $BROWSER
    browser: chromium
    lang: en_US.UTF-8
    # Set your default $TERM
    term: alacritty
    # Include things to your $PATH
    path:
      - ~/bin
    # zsh plugins
    plugins:
      - sudo
      - git

    # i3 configs (default WM; swap tasks/main.yml roles to use jahrik.sway instead)
    i3:
      lock: true
      bar: false    # false = polybar, true = conky i3bar
      polybar: true
      terminal: alacritty

    # Python/Ansible color output
    python_force_color: 1
    ansible_force_color: 1

## Dependencies

| Role | CI |
|------|----|
| jahrik.yay | [![CI](https://github.com/jahrik/ansilbe-yay/actions/workflows/cicd.yml/badge.svg)](https://github.com/jahrik/ansilbe-yay/actions/workflows/cicd.yml) |
| jahrik.alacritty | [![CI](https://github.com/jahrik/ansible-alacritty/actions/workflows/cicd.yml/badge.svg)](https://github.com/jahrik/ansible-alacritty/actions/workflows/cicd.yml) |
| jahrik.i3_gaps | [![CI](https://github.com/jahrik/ansible-i3-gaps/actions/workflows/cicd.yml/badge.svg)](https://github.com/jahrik/ansible-i3-gaps/actions/workflows/cicd.yml) |
| jahrik.polybar | [![CI](https://github.com/jahrik/ansible-polybar/actions/workflows/cicd.yml/badge.svg)](https://github.com/jahrik/ansible-polybar/actions/workflows/cicd.yml) |
| jahrik.urxvt | [![CI](https://github.com/jahrik/ansible-urxvt/actions/workflows/cicd.yml/badge.svg)](https://github.com/jahrik/ansible-urxvt/actions/workflows/cicd.yml) |
| jahrik.conky | [![CI](https://github.com/jahrik/ansible-conky/actions/workflows/cicd.yml/badge.svg)](https://github.com/jahrik/ansible-conky/actions/workflows/cicd.yml) |
| jahrik.zsh | [![CI](https://github.com/jahrik/ansible-zsh/actions/workflows/cicd.yml/badge.svg)](https://github.com/jahrik/ansible-zsh/actions/workflows/cicd.yml) |
| jahrik.vim | [![CI](https://github.com/jahrik/ansible-vim/actions/workflows/cicd.yml/badge.svg)](https://github.com/jahrik/ansible-vim/actions/workflows/cicd.yml) |
| jahrik.nvim | [![CI](https://github.com/jahrik/ansible-nvim/actions/workflows/cicd.yml/badge.svg)](https://github.com/jahrik/ansible-nvim/actions/workflows/cicd.yml) |

## Example Playbook

    - hosts: localhost
      roles:
         - { role: jahrik.workstation, install: true }

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
    station wlan0 get-networks
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

## Testing

```bash
# Lint
yamllint .
ansible-lint

# Molecule (Docker, Arch only)
molecule test
```
