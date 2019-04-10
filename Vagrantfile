# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/precise32"

  config.vm.define :db do |db_config|
    db_config.vm.network :private_network, :ip => "192.168.33.10"

    db_config.vm.provision :"shell", path: "install_puppet.sh"
    db_config.vm.provision "puppet" do |puppet|
    	puppet.manifest_file = "db.pp"
    end
  end

  config.vm.define :web do |web_config|
    web_config.vm.network :private_network, :ip => "192.168.33.12"

    web_config.vm.provision :"shell", path: "install_puppet.sh"
    web_config.vm.provision "puppet" do |puppet|
        puppet.manifest_file = "web.pp"
    end
  end

end
