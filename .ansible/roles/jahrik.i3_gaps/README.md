# ansible-i3-gaps

[![CICD](https://github.com/jahrik/ansible-i3-gaps/actions/workflows/cicd.yml/badge.svg)](https://github.com/jahrik/ansible-i3-gaps/actions/workflows/cicd.yml)

Install and configure [i3-gaps](https://github.com/Airblader/i3) tiling window manager along with a full set of supporting packages (conky, dunst, feh, dmenu, scrot, etc.) and deploy templated config files to `~/.config/i3/`. Supports Arch Linux and Debian/Ubuntu.

## Requirements

None beyond Ansible itself.

## Role Variables

| Variable | Default | Description |
|---|---|---|
| `install` | `true` | Set to `false` to uninstall i3 and remove config files |
| `i3.lock` | `true` | Enable i3lock |
| `i3.bar` | `false` | Use i3bar (false = use polybar) |
| `i3.polybar` | `true` | Enable polybar |
| `i3.terminal` | `alacritty` | Default terminal emulator |
| `conky.update_int` | `2` | Conky update interval (seconds) |
| `conky.interface` | `ansible_default_ipv4.interface` | Network interface for conky |

## Dependencies

None (Arch packages installed directly via pacman).

## Example Playbook

```yaml
- hosts: workstations
  roles:
    - role: jahrik.i3_gaps
```

To uninstall:

```yaml
- hosts: workstations
  roles:
    - role: jahrik.i3_gaps
      vars:
        install: false
```

## Testing

```bash
# Lint
yamllint .

# Full molecule test (Arch + Ubuntu containers)
molecule test

# Iterative
molecule converge
molecule destroy
```

## License

GPLv2
