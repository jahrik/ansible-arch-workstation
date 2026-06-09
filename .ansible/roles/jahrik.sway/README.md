Sway
=======

[![CICD](https://github.com/jahrik/ansible-sway/actions/workflows/cicd.yml/badge.svg)](https://github.com/jahrik/ansible-sway/actions/workflows/cicd.yml)

Installs and configures Sway

## Suports

* Archlinux
* Ubuntu

Example Playbook
----------------

```yaml
---
- hosts: all
  become: true
  roles:
    - jahrik.sway
  vars:
    install: true
    sway:
      lock: true
      bar: swayrbar
      terminal: alacritty
      mod: Mod1
      left: h
      down: j
      up: k
      right: l
      background: ~/.config/sway/background.jpg
```

License
-------

GPLv2

Author Information
------------------

jahrik@gmail.com

https://homelab.business/
