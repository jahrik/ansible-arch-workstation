# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "cloud-image/arch-linux"
  config.vm.hostname = "archie.dev"
  config.ssh.forward_x11 = true
  config.vm.synced_folder ".", "/vagrant", type: "rsync",
    rsync__exclude: [".git/", ".vagrant/", ".ansible/"]

  config.vm.provider :qemu do |qemu|
    qemu_bin_dirs = ["/usr/bin", "/opt/homebrew/bin", "/usr/local/bin"]
    qemu.qemu_dir = qemu_bin_dirs.find { |d| File.exist?("#{d}/qemu-system-x86_64") } || "/usr/bin"
    qemu.memory = "4096M"
    qemu.cpus = 2
    qemu.arch = "x86_64"
    qemu.machine = "q35"
    qemu.cpu = "host"
    qemu.net_device = "virtio-net-pci"
    qemu.extra_qemu_args = File.exist?("/dev/kvm") ? %w(-enable-kvm) : []
  end

  config.vm.provider :virtualbox do |vb|
    vb.memory = 4096
    vb.cpus = 2
  end

  config.vm.provision "shell", inline: <<-SHELL
    pacman --noconfirm -Syu
    pacman --noconfirm -S git ansible python xorg-server xorg-xinit xorg-xrandr
    mkdir -p /etc/ansible/roles
    ln -sf /vagrant /etc/ansible/roles/jahrik.workstation
    ansible-galaxy install -r /vagrant/requirements.yml -p /etc/ansible/roles
  SHELL

  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "playbook.yml"
    ansible.install = false
  end
end
