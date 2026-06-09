# ZSH

[![CICD](https://github.com/jahrik/ansible-zsh/actions/workflows/cicd.yml/badge.svg)](https://github.com/jahrik/ansible-zsh/actions/workflows/cicd.yml)

Install ZSH, oh-my-zsh, and configure some defaults.

## Requirements

- git

## Role Variables

    theme: robbyrussell
    editor: vim
    browser: chromium
    lang: en_US.UTF-8
    term: rxvt
    path:
      - ~/bin
    plugins:
      - sudo
      - git
    aws:
      access_key_id:
      secret_access_key:
    chef:
      user:
      url:
      repo:
      log_level:
    python_force_color: 1
    ansible_force_color: 1

## Dependencies

## Example Playbook

    - hosts: local
      roles:
         - { role: jahrik.zsh, theme: robbyrussell }

## License

GPLv2

## Author Information

jahrik@gmail.com

https://homelab.business/
