# ansible-i3-gaps

Installs [i3-gaps](https://github.com/Airblader/i3) tiling window manager and a full desktop stack (conky, dunst, feh, dmenu, scrot, xorg tools). Deploys templated config files (`config`, `conkyrc`, `dunstrc`, `xinitrc`, `xmodmap`) to `~/.config/i3/` and symlinks `~/.xinitrc`. Supports Arch Linux and Debian/Ubuntu. Can uninstall via the `install` variable.

## Key Variables

| Variable | Default | Description |
|---|---|---|
| `install` | `true` | Set to `false` to uninstall i3 and remove config files |
| `i3.lock` | `true` | Enable i3lock |
| `i3.bar` | `false` | Use i3bar (false = polybar) |
| `i3.polybar` | `true` | Enable polybar |
| `i3.terminal` | `alacritty` | Default terminal |
| `conky.update_int` | `2` | Conky update interval (seconds) |
| `conky.interface` | `ansible_default_ipv4.interface` | Network interface |

## Task Flow

`tasks/main.yml` → `install.yml` or `uninstall.yml` based on `install | bool`

**install.yml:**
1. Include `archlinux.yml` or `debian.yml` for OS packages
2. Create `~/.config/i3/` directory
3. Template all config files to `~/.config/i3/`
4. Symlink `~/.xinitrc` → `~/.config/i3/xinitrc`
5. Create `~/screenshots/` for scrot
6. Copy `background.jpg`

**archlinux.yml:** `community.general.pacman` for i3-gaps, i3lock, i3status, and extras

**debian.yml:** Regolith PPA → apt install

**uninstall.yml:** removes packages, `~/.config/i3`, and `~/.xinitrc`

## Testing

```bash
# Lint
PATH="$HOME/.venv/ansible/bin:$PATH" yamllint .

# Full test (Arch + Ubuntu)
mtest test

# Iterative
mtest converge
mtest destroy
```
