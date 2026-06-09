# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

## Role Overview

Installs [Vim](https://www.vim.org/) with [Vundle](https://github.com/VundleVim/Vundle.vim) plugin manager and deploys a fully configured `~/.vimrc` from a Jinja2 template. Plugins, key mappings, set options, and colorscheme are all controlled via `defaults/main.yml`.

## Key Variables

| Variable | Default | Description |
|---|---|---|
| `install` | `true` | Set to `false` to uninstall vim and backup config |
| `vundle` | (list) | Vundle plugins to install |
| `set` | (list) | Vim `:set` options |
| `map` | (list) | Key mappings |
| `nmap` | (list) | Normal-mode mappings |
| `colorscheme` | `slate` | Vim colorscheme |
| `let` | (list) | Vim `let` variable assignments |

## Task Flow

- `tasks/main.yml` — branches install/uninstall on `install` var
- `tasks/install.yml` — updates apt cache (Debian), installs vim + git, clones Vundle, templates `~/.vimrc`, creates spell-check file
- `tasks/uninstall.yml` — removes packages, backs up `~/.config/vim` and `~/.vimrc` to `/tmp/vim`, removes originals

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
