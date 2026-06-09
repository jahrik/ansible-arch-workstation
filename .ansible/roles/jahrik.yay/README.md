# Yay

[![CICD](https://github.com/jahrik/ansilbe-yay/actions/workflows/cicd.yml/badge.svg)](https://github.com/jahrik/ansilbe-yay/actions/workflows/cicd.yml)

Installs [yay](https://github.com/Jguer/yay)

## Requirements

- base-devel
- git

## Role Variables

Set to install or uninstall and cleanup

    install: true/false

This can be set to install any additional software form the AUR after yay is installed and ready to use.

    aur_packages:
      - polybar-git

## Dependencies

None

## Example Playbook

    - hosts: all
      roles:
         - { role: jahrik.yay, install: true }

## License

GPLv2

## Author Information

jahrik@gmail.com

https://homelab.business/
