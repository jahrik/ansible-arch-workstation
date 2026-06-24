# Arch Workstation

[![CICD](https://github.com/jahrik/ansible-arch-workstation/actions/workflows/cicd.yml/badge.svg)](https://github.com/jahrik/ansible-arch-workstation/actions/workflows/cicd.yml)
[![Ansible Galaxy](https://img.shields.io/badge/ansible--galaxy-jahrik.workstation-blue?logo=ansible)](https://galaxy.ansible.com/ui/standalone/roles/jahrik/workstation/)

Meta-role that installs a full Arch Linux development environment by composing `jahrik.*` roles. Arch Linux only.

## Usage

Install dependencies from Ansible Galaxy:

```bash
ansible-galaxy install -r requirements.yml
```

Run against localhost:

```bash
ansible-playbook -l local playbook.yml
```

### Example Playbook

```yaml
---
- hosts: localhost
  roles:
    - role: jahrik.workstation
```

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

- jahrik.yay
- jahrik.alacritty
- jahrik.i3_gaps
- jahrik.polybar
- jahrik.urxvt
- jahrik.conky
- jahrik.zsh
- jahrik.vim
- jahrik.nvim

## Testing

```bash
uv sync
source .venv/bin/activate
yamllint .
ansible-lint
molecule test
```

## License

GPLv2
