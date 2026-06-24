# ansible-arch-workstation

Top-level Ansible role that configures a complete Arch Linux development workstation by composing several `jahrik.*` sub-roles from Ansible Galaxy. This is the entry point — one playbook run installs and configures the entire environment. Arch Linux only; no support for other distributions.

## Key Variables

| Variable | Default | Description |
|---|---|---|
| `time_zone` | `US/Pacific` | System timezone |
| `locale` | `en_US.UTF-8 UTF-8` | System locale |
| `theme` | `robbyrussell` | Oh My Zsh theme |
| `editor` | `nvim` | Default `$EDITOR` |
| `browser` | `chromium` | Default `$BROWSER` |
| `terminal` | `alacritty` | Default `$TERM` |
| `i3.bar` | `false` | Use conky i3bar instead of polybar |
| `i3.polybar` | `true` | Enable polybar |

## Task Flow

`tasks/main.yml` runs each sub-role in order via `ansible.builtin.include_role`:

1. `jahrik.yay` — AUR helper
2. `jahrik.alacritty` — terminal emulator + TOML config
3. `jahrik.i3_gaps` — i3-gaps window manager + config
4. `jahrik.polybar` — status bar
5. `jahrik.urxvt` — X11 terminal emulator
6. `jahrik.conky` — system monitor / i3 bar widget
7. `jahrik.zsh` — shell + Oh My Zsh
8. `jahrik.vim` — Vim + Vundle + plugins
9. `jahrik.nvim` — Neovim + Packer + LSP

There is no install/uninstall branching at this level; toggling is done via each sub-role's own `install` variable.

## Testing

```bash
uv sync
source .venv/bin/activate
yamllint .
ansible-lint
molecule test
```

## CI

- **Lint**: yamllint + ansible-lint
- **Molecule**: Arch Linux via Docker (`molecule/default`)
- **Release**: publishes to Ansible Galaxy on merge to `main`
