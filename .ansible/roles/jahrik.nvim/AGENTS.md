# ansible-nvim

Installs [Neovim](https://neovim.io/) and deploys a full Lua-based configuration to `~/.config/nvim/`. Sets up LSP support, Packer plugins, Nerd Fonts, and the `neovim` npm and Python packages. Supports Arch Linux and Debian/Ubuntu.

## Key Variables

| Variable | Default | Description |
|---|---|---|
| `install` | `true` | Set to `false` to uninstall neovim and remove `~/.config/nvim` |

## Task Flow

`tasks/main.yml` → `install.yml` or `uninstall.yml` based on `install | bool`

**install.yml:**
1. Include `archlinux.yml` or `debian.yml` for OS dependencies
2. Create `~/.local/share/fonts` and download DejaVu Nerd Fonts
3. Install `neovim` package
4. Install `neovim` npm package globally
5. Create Python virtualenv at `/usr/local/share/nvim/python3` with `neovim` module
6. Create `~/.config/nvim/` directory tree
7. Copy all Lua config files (`init.lua`, `lua/conf/*.lua`, `after/plugin/*.lua`)

**archlinux.yml:** `community.general.pacman` installs fd, nodejs, npm, python-pynvim, ripgrep, etc.

**debian.yml:** apt + Neovim unstable PPA + NodeSource repo for newer nodejs

**uninstall.yml:** removes `neovim` package and `~/.config/nvim`
