# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

## Role Overview

Ansible role that installs [Alacritty](https://github.com/alacritty/alacritty) and writes its config. Supports Arch Linux and Ubuntu. Tested with Molecule against both platforms via Docker.

## Key Variables (`defaults/main.yml`)

| Variable | Default | Description |
|---|---|---|
| `install` | `true` | Set to `false` to uninstall and remove config |
| `alacritty.font.size` | `16` | Font size in the generated config |
| `alacritty.font.family` | `DejaVuSansMono Nerd Font Mono` | Font family |

## Task Flow

- `tasks/main.yml` — branches on `install` to call `install.yml` or `uninstall.yml`
- `tasks/install.yml` — runs `debian.yml` if on Debian family, then installs the package and templates `~/.config/alacritty/alacritty.yml`
- `templates/alacritty.yml.j2` — Srcery color scheme hardcoded; font pulled from vars

## Testing

```bash
# Lint
yamllint .

# Run molecule (Docker — tests Ubuntu 20.04 and Arch)
molecule test

# Run against a specific platform only
molecule converge -- --limit ubuntu
molecule converge -- --limit arch
```

CI runs lint + molecule on push to `main` via `.github/workflows/cicd.yml`.
