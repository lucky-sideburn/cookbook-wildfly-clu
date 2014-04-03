# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "Berkshelf-CentOS-6.3-x86_64-minimal"
  #config.vm.box_url = "https://dl.dropbox.com/u/31081437/Berkshelf-CentOS-6.3-x86_64-minimal.box"
  config.vm.box_url = "https://s3.amazonaws.com/itmat-public/centos-6.3-chef-10.14.2.box"
  config.vm.define "myserver1" do |myserver1|
   myserver1.vm.hostname = "myserver1" 
   myserver1.vm.network :private_network, ip: "33.33.33.11"
   myserver1.vm.network :public_network
   myserver1.vm.provision :chef_solo do |chef|
    chef.json = {
     :java => {:jdk_version  => "7"}

     }

    chef.run_list = [
        "recipe[java]",
        "recipe[wildfly-clu::default]",
        "recipe[wildfly-clu::logs]",
        "recipe[wildfly-clu::domain]"

    ]
   end
  end

  config.vm.define "myserver2" do |myserver2|
   myserver2.vm.hostname = "myserver2"
   myserver2.vm.network :private_network, ip: "33.33.33.12"
   myserver2.vm.network :public_network
   myserver2.vm.provision :chef_solo do |chef|
    chef.json = {
     :java => {:jdk_version  => "7"}

     }

    chef.run_list = [
        "recipe[java]",
        "recipe[wildfly-clu::default]",
        "recipe[wildfly-clu::logs]",
        "recipe[wildfly-clu::domain]"

    ]
  end 
 end

  config.vm.define "myserver3" do |myserver3|
   myserver3.vm.hostname = "myserver3"
   myserver3.vm.network :private_network, ip: "33.33.33.13"
   myserver3.vm.network :public_network
   myserver3.vm.provision :chef_solo do |chef|
    chef.json = {
     :java => {:jdk_version  => "7"}

     }

    chef.run_list = [
        "recipe[java]",
        "recipe[wildfly-clu::default]",
        "recipe[wildfly-clu::logs]",
        "recipe[wildfly-clu::domain]"

  
 ]
  end 
 end


  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    chef.json = {
     :java => {:jdk_version  => "7"}   

     }

    chef.run_list = [
        #"recipe[java]",
        #"recipe[wildfly-clu::default]",
        #"recipe[wildfly-clu::logs]",
        #"recipe[wildfly-clu::domain]"
    ]
  end
end
