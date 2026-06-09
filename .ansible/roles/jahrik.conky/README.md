## Conky

[![CICD](https://github.com/jahrik/ansible-conky/actions/workflows/cicd.yml/badge.svg)](https://github.com/jahrik/ansible-conky/actions/workflows/cicd.yml)

Install Conky and basic configs

![screenshot of conky](./conky.png)

## Requirements

None

## Role Variables

Install or uninstall and remove conifg file

    install: true

Conky variables

    conky:
      font: DejaVuSansMono Nerd Font Mono
      update_int: 2
      color_01: FFCC99
      color_02: 33CC33
      color_03: 33CC99
      interface: "{{ ansible_default_ipv4['interface'] }}"

## Dependencies

None

## Example Playbook

    - hosts: all
      become: true
      vars:
        install: true
      roles:
        - jahrik.conky

## License

GPLv2

## Author Information

jahrik@gmail.com

https://homelab.business/
