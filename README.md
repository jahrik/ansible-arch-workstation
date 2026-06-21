# Arch Workstation

[![CICD](https://github.com/jahrik/ansible-arch-workstation/actions/workflows/cicd.yml/badge.svg)](https://github.com/jahrik/ansible-arch-workstation/actions/workflows/cicd.yml)
[![Ansible Galaxy](https://img.shields.io/badge/ansible--galaxy-jahrik.workstation-blue?logo=ansible)](https://galaxy.ansible.com/ui/standalone/roles/jahrik/workstation/)

Meta-role that installs a full Arch Linux development environment by composing jahrik.* roles. Arch Linux only — does not support Debian, macOS, or SteamOS.

<!-- vim-markdown-toc GFM -->

* [OS Support](#os-support)
* [Role Variables](#role-variables)
* [Dependencies](#dependencies)
* [Example Playbook](#example-playbook)
* [Testing](#testing)
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

## OS Support

Arch Linux only. Run this role on a fresh Arch install to bring up a complete desktop environment.

## Role Variables

| Variable | Default | Description |
|---|---|---|
| `time_zone` | `US/Pacific` | System timezone |
| `locale` | `en_US.UTF-8 UTF-8` | System locale |
| `base` | `[git, sudo]` | Base packages to install |
| `editor` | `nvim` | Default `$EDITOR` |
| `browser` | `chromium` | Default `$BROWSER` |
| `lang` | `en_US.UTF-8` | `$LANG` env var |
| `term` | `alacritty` | Default `$TERM` |
| `path` | `[~/bin]` | Extra `$PATH` entries |
| `i3.lock` | `true` | Enable i3lock |
| `i3.bar` | `false` | `false` = polybar, `true` = conky i3bar |
| `i3.polybar` | `true` | Enable polybar |
| `i3.terminal` | `alacritty` | i3 default terminal |
| `python_force_color` | `1` | `PY_COLORS` env var |
| `ansible_force_color` | `1` | `ANSIBLE_FORCE_COLOR` env var |

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

```yaml
---
- hosts: localhost
  roles:
    - role: jahrik.workstation
```

## Testing

```bash
yamllint .
ansible-lint
molecule test
```

## License

GPLv2

## Author Information

jahrik@gmail.com

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

