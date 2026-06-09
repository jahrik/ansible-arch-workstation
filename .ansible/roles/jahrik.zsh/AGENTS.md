# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

## Role Overview

Installs [Zsh](https://www.zsh.org/) with [Oh My Zsh](https://ohmyz.sh/) and deploys a fully configured shell environment to `~/.config/zsh/`. Symlinks `~/.zshrc` and `~/.zshenv` to the config directory. Sets zsh as the default user shell.

## Key Variables

| Variable | Default | Description |
|---|---|---|
| `theme` | `robbyrussell` | Oh My Zsh theme |
| `editor` | `vim` | Default `$EDITOR` |
| `browser` | `chromium` | Default `$BROWSER` |
| `lang` | `en_US.UTF-8` | Default `$LANG` |
| `path` | `[~/bin]` | Extra entries for `$PATH` |
| `plugins` | `[sudo, git]` | Oh My Zsh plugins to load |
| `user` | `$USER` | User to set shell for |

## Task Flow

- `tasks/main.yml` — updates package cache, installs git + zsh, creates `~/.config/zsh`, clones Oh My Zsh, templates all config files, symlinks `~/.zshrc`/`~/.zshenv`, sets default shell

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
