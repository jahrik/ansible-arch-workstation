# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "archlinux/archlinux"
  config.vm.provider :virtualbox do |vb|
    vb.cpus = 2
    vb.gui = true
    vb.customize ["modifyvm", :id, "--memory", "4096"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
    vb.customize ["modifyvm", :id, "--vram", "256"]
  end
  config.ssh.forward_x11 = true
  config.vm.network 'private_network', ip: '192.168.56.11'
  config.vm.hostname = 'archie.dev'
  config.vm.provision "shell", inline: %{
    pacman --noconfirm -Syu
    pacman --noconfirm -S xorg-server xorg-xinit xorg-xrandr
  }
end
