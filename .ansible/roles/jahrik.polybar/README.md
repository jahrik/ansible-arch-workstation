# Polybar

[![CICD](https://github.com/jahrik/ansible-polybar/actions/workflows/cicd.yml/badge.svg)](https://github.com/jahrik/ansible-polybar/actions/workflows/cicd.yml)

Install and configure [Polybar](https://github.com/polybar/polybar), a fast and easy-to-use status bar. Deploys config and launch script to `~/.config/polybar/`.

- **Arch Linux**: installs latest from AUR via `jahrik.yay`
- **Debian/Ubuntu**: builds from source at the version specified in `polybar.version`

## Requirements

- Arch Linux: depends on `jahrik.yay` role for AUR package installation

## Role Variables

| Variable | Default | Description |
|---|---|---|
| `polybar.version` | `3.5.7` | Polybar source version (Debian/Ubuntu only) |

## Dependencies

- `jahrik.yay` (Arch Linux only)

## Example Playbook

```yaml
- hosts: workstations
  roles:
    - role: jahrik.polybar
```

## Testing

```bash
# Lint
yamllint .

# Full molecule test (Arch container)
molecule test

# Iterative
molecule converge
molecule destroy
```

## License

GPLv2
