# -*- mode: ruby -*-
# vi: set ft=ruby :
 
Vagrant.configure("2") do |config|

  config.vm.box = "generic/ubuntu2004"
  config.vm.synced_folder './', '/vagrant'
  config.vm.hostname = "vagrant"
  config.vm.network "forwarded_port", guest: 8888, host: 8888

  config.ssh.insert_key = true
  config.ssh.username = "vagrant"
  config.ssh.password = "vagrant"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 8192
    vb.cpus = 4
    vb.gui = false
  end

  config.vm.provision "shell", path: "vagrant.sh"
 
end