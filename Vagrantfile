# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'socket'


# Retrieve VM configuration from .travis.yml file so that local Vagrant
# execution is as close as possible to Travis CI triggered on pull requests
require 'yaml'
travis_config = YAML.load_file(".travis.yml")
box_name = "ubuntu/" + travis_config['matrix']['include'][0]['dist'] + "64"

packages = [ '#!/bin/sh', '' ] + travis_config['before_install']
File.open("scripts/vagrant/travis_packages.sh", "w+") do |f|
  packages.each { |element| f.puts(element) }
end

mapcache = [ '#!/bin/sh', '', 'cd /vagrant' ] \
           + travis_config['matrix']['include'][0]['env'] \
           + travis_config['script']
File.open("scripts/vagrant/travis_mapcache.sh", "w+") do |f|
  mapcache.each { |element| f.puts(element) }
end


# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = box_name

  config.vm.hostname = "mapcache-vagrant"

  config.vm.network :forwarded_port, guest: 80, host: 8080

  config.vm.provider "virtualbox" do |v|
     v.customize ["modifyvm", :id, "--memory", 1024, "--cpus", 2]
     v.customize ["modifyvm", :id, "--ioapic", "on", "--largepages", "off", "--vtxvpid", "off"]
     v.name = "mapcache-vagrant"
   end

  config.vm.provision "shell", path: "scripts/vagrant/virtualbox-fix.sh"
  config.vm.provision "shell", path: "scripts/vagrant/travis_packages.sh"
  config.vm.provision "shell", path: "scripts/vagrant/travis_mapcache.sh"

end
