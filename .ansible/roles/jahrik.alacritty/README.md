## ALACRITTY

[![CICD](https://github.com/jahrik/ansible-alacritty/actions/workflows/cicd.yml/badge.svg)](https://github.com/jahrik/ansible-alacritty/actions/workflows/cicd.yml)

Install alacritty and configurations

Configurations are based on [en0's dotfiles](https://github.com/en0/dotfiles)

## Requirements

### Ubuntu

The latest version of alacritty will install from [ppa:aslatter/ppa](https://launchpad.net/~aslatter/+archive/ubuntu/ppa)

## Role Variables

Install or uninstall and cleanup directories and packages

    install: true

TODO:


## Dependencies

None

## Example Playbook

    - hosts: all
      become: true
      vars:
        install: true
      roles:
        - jahrik.alacritty

## License

GPLv2

## Author Information

jahrik@gmail.com

https://homelab.business/
