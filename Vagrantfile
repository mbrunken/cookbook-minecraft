# vi: set ft=ruby :


Vagrant::Config.run do |config|

  server_port = 25565

  config.vm.box = "squeeze64"
  config.vm.box_url = "http://debbuild.bigpoint.net/squeeze64.box"
  config.vm.host_name = "minecraft-server"
  config.vm.customize ['modifyvm', :id, '--memory', 2048]
  config.vm.forward_port server_port, server_port

  config.vm.provision :chef_solo do |chef|

    chef.add_recipe "minecraft"


    chef.json = {


    }
    chef.log_level = :debug
  end
end
