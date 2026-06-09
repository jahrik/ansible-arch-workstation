# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

## Role Overview

Installs and configures [Polybar](https://github.com/polybar/polybar), a fast and easy-to-use status bar. On Arch Linux, installs from AUR via `jahrik.yay`. On Debian/Ubuntu, builds from source. Deploys `~/.config/polybar/config` and `~/.config/polybar/launch.sh` from templates.

## Key Variables

| Variable | Default | Description |
|---|---|---|
| `polybar.version` | `3.5.7` | Source version to build on Debian/Ubuntu (Arch always gets latest from AUR) |

## Task Flow

- `tasks/main.yml` — includes `debian.yml` or `archlinux.yml` based on OS family, then deploys config templates
- `tasks/archlinux.yml` — installs via `jahrik.yay` (AUR)
- `tasks/debian.yml` — updates apt cache, installs build dependencies, downloads and compiles from source

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
