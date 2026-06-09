# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

## Role Overview

Installs and configures [rxvt-unicode (urxvt)](http://software.schmorp.de/pkg/rxvt-unicode.html), a lightweight terminal emulator. Deploys Xresources color schemes (dark/light) to `~/.urxvt/` and installs the font-size and keyboard-select/url-select plugins.

## Key Variables

| Variable | Default | Description |
|---|---|---|
| `install` | `true` | Set to `false` to skip install |
| `browser` | `chromium` | Default browser (referenced in config templates) |
| `text.font` | `DejaVuSansMono Nerd Font` | Font family |
| `text.size` | `18` | Font size |

## Task Flow

- `tasks/main.yml` — includes OS-specific tasks, creates `~/.urxvt/ext/`, templates config files, downloads font-size plugin, symlinks keyboard-select/url-select (Arch only)
- `tasks/archlinux.yml` — installs via `community.general.pacman`
- `tasks/debian.yml` — updates apt cache, installs via `apt`

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
