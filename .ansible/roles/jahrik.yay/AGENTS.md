# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

## Role Overview

Installs [yay](https://github.com/Jguer/yay), an AUR helper for Arch Linux, by cloning the AUR repo and running `makepkg`. Includes a custom `library/yay` Python module for installing arbitrary AUR packages after yay is set up.

## Key Variables

| Variable | Default | Description |
|---|---|---|
| `install` | `true` | Set to `false` to uninstall yay |
| `aur_packages` | `[]` | List of AUR packages to install after yay is set up |

## Task Flow

- `tasks/main.yml` — branches install/uninstall on `install` var
- `tasks/install.yml` — installs `base-devel` + `git` via pacman, clones yay from AUR, builds with `makepkg`, installs any `aur_packages` using the custom `yay` module
- `tasks/uninstall.yml` — removes yay package and `/tmp/yay`
- `library/yay` — custom Ansible module for installing AUR packages using yay

## Testing Commands

```bash
# Lint
yamllint .

# Full molecule test (Arch container)
molecule test

# Iterative
molecule converge
molecule destroy
```
