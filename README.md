# Ansible workstation configuration for development

## TODO

## Vagrant lab

Bring up an arch box

    vagrant up

Check the status of vagrant

    vagrant status
    Current machine states:

    arch-vm              running (virtualbox)

SSH into a box

    vagrant ssh arch-vm.dev


Run the playbook against the vm

    ansible-playbook site.yml
