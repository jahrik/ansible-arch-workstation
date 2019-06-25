# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative './key_authorization.rb'

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "generic/arch"
  config.vm.provider :virtualbox do |vb|
    vb.cpus = 2
    vb.gui = true
    vb.customize ["modifyvm", :id, "--memory", "4096"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
    vb.customize ["modifyvm", :id, "--vram", "256"]
  end

  config.vm.provision "shell", inline: "mkdir -p /root/.ssh"
  authorize_key_for_root config, '~/.ssh/id_dsa.pub', '~/.ssh/id_rsa.pub'

  config.ssh.forward_x11 = true
  config.vm.network 'private_network', ip: '192.168.33.11'
  config.vm.hostname = 'archie.dev'

  config.vm.provision "shell", inline: "pacman --noconfirm -S virtualbox-guest-modules-arch"
end
