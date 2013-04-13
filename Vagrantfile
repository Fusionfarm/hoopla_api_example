# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box     = 'precise64'
  config.vm.box_url = 'http://files.vagrantup.com/precise64.box'
  config.vm.network :forwarded_port, host: 3000, guest: 9292

  config.vm.provider :virtualbox do |vb|
    # If things are going slow, you can adjust the amount of CPUs and RAM.
    #
    #     vb.customize ['modifyvm', :id, '--cpus', 4, '--memory', 1024 * 4]
  end
  
  config.vm.provision(:shell, :path => 'script/vagrant-provision')
end
