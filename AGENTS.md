# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

## Role Overview

Top-level Ansible role that configures a full Arch Linux development workstation by composing several sub-roles from Ansible Galaxy. This is the entry point — it installs and configures the entire environment in one playbook run.

## Composed Roles (`requirements.yml`)

Installed via `ansible-galaxy install -r requirements.yml`:

| Role | Purpose |
|---|---|
| `jahrik.yay` | AUR helper (Arch only) |
| `jahrik.alacritty` | Terminal emulator + config |
| `jahrik.sway` | Wayland compositor + config |
| `jahrik.zsh` | Shell + Oh My Zsh |
| `jahrik.vim` | Vim + Vundle + plugins |
| `jahrik.nvim` | Neovim + Packer + LSP |

## Key Variables (`defaults/main.yml`)

| Variable | Default | Description |
|---|---|---|
| `install` | `true` | Set to `false` to uninstall |
| `time_zone` | `US/Pacific` | System timezone |
| `locale` | `en_US.UTF-8 UTF-8` | System locale |
| `theme` | `robbyrussell` | Oh My Zsh theme |
| `editor` | `nvim` | Default `$EDITOR` |
| `browser` | `chromium` | Default `$BROWSER` |
| `i3.bar` | `false` | Use polybar instead of conky bar |
| `i3.polybar` | `true` | Enable polybar |

## Commands

```bash
# Install Galaxy role dependencies
ansible-galaxy install -r requirements.yml

# Run the full playbook
ansible-playbook playbook.yml -i inventory.ini

# Lint
yamllint .

# Test with Molecule (Docker, Arch only)
molecule test

# Test with Vagrant (VirtualBox, full GUI — needs xorg pre-installed)
molecule test -s vagrant
```

## Molecule Scenarios

- `default` — Docker, Arch Linux (`jahrik/docker-archlinux-ansible`)
- `vagrant` — VirtualBox, `archlinux/archlinux` box, 4GB RAM, GUI enabled with X11 forwarding
- `mac` — macOS (see `molecule/mac/INSTALL.rst`)
