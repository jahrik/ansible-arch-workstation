## NEOVIM

[![CICD](https://github.com/jahrik/ansible-nvim/actions/workflows/cicd.yml/badge.svg)](https://github.com/jahrik/ansible-nvim/actions/workflows/cicd.yml)

Installs neovim and configures it with Lua.

Uses [packer](https://github.com/wbthomason/packer.nvim) for plugins management. Bootstraps packer, if it's not already installed.

Installs [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/DejaVuSansMono.zip) to

    ~/.local/share/fonts

## Plugins

The following plugins are installed and configured

* nvim-telescope
* nightfox
* nvim-tree
* nvim-web-devicons
* barbar
* filetype
* better-whitespace
* lualine
* vim-test
* which-key.nvim
* treesitter
* trouble
* lsp-zero

## OS Support

* Arch

* Ubuntu

## Role Variables

Install or uninstall and cleanup directories and packages

    install: true

## Dependencies

None

## Example Playbook

    - hosts: all
      become: true
      vars:
        install: true
      roles:
        - jahrik.nvim

## Testing

```bash
molecule test
```

Or step by step:

```bash
molecule converge
molecule verify
molecule destroy
```

## License

GPLv2

## Author Information

jahrik@gmail.com

https://homelab.business/
