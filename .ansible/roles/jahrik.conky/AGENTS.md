# ansible-conky

Installs [Conky](https://github.com/brndnmtthws/conky) system monitor and deploys a templated `~/.conkyrc` config file. Supports Arch Linux and Debian/Ubuntu. Can also uninstall via the `install` variable.

## Key Variables

| Variable | Default | Description |
|---|---|---|
| `install` | `true` | Set to `false` to uninstall conky and remove `~/.conkyrc` |
| `conky.font` | `DejaVuSansMono Nerd Font Mono` | Font used in conkyrc |
| `conky.update_int` | `2` | Conky update interval (seconds) |
| `conky.color1` | `FFCC99` | Primary color (hex) |
| `conky.color2` | `33CC33` | Secondary color (hex) |
| `conky.color3` | `33CC99` | Tertiary color (hex) |
| `conky.interface` | `ansible_default_ipv4.interface` | Network interface to display |

## Task Flow

`tasks/main.yml` → `install.yml` or `uninstall.yml` based on `install | bool`

**install.yml:**
- Arch: `community.general.pacman` installs `conky`
- Debian: `ansible.builtin.apt` installs `conky-all`
- All: template `conkyrc.j2` → `~/.conkyrc`

**uninstall.yml:** removes `conky`/`conky-all` package and `~/.conkyrc`

## Testing

```bash
# Lint
PATH="$HOME/.venv/ansible/bin:$PATH" yamllint .

# Full test (Arch + Ubuntu containers)
mtest test

# Iterative
mtest converge
mtest destroy
```
