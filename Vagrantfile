VAGRANTFILE_API_VERSION = "2"

base_dir = File.expand_path(File.dirname(__FILE__))
cluster = {
  "mesos-master1" => { :ip => "100.0.10.11",  :cpus => 1, :mem => 512 },
  "mesos-master2" => { :ip => "100.0.10.12",  :cpus => 1, :mem => 512 },
  "mesos-master3" => { :ip => "100.0.10.13",  :cpus => 1, :mem => 512 },
  "mesos-slave1"  => { :ip => "100.0.10.101", :cpus => 1, :mem => 256 },
  "mesos-slave2"  => { :ip => "100.0.10.102", :cpus => 1, :mem => 256 },
  "mesos-slave3"  => { :ip => "100.0.10.103", :cpus => 1, :mem => 256 },
  "haproxy1"      => { :ip => "100.0.10.21",  :cpus => 1, :mem => 256 }
}

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :machine
    config.cache.enable :apt
  end

  cluster.each do |hostname, info|

    config.vm.define hostname do |cfg|

      cfg.vm.provider :virtualbox do |vb, override|
        override.vm.box = "trusty64"
        override.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
        override.vm.network :private_network, ip: "#{info[:ip]}"
        override.vm.hostname = hostname

        vb.name = 'vagrant-mesos-' + hostname
        vb.customize ["modifyvm", :id, "--memory", info[:mem], "--cpus", info[:cpus], "--hwvirtex", "on" ]
      end

      # provision nodes with ansible
      cfg.vm.provision :ansible do |ansible|
        ansible.verbose = "v"

        ansible.inventory_path = "ansible/vagrant"
        ansible.playbook = "ansible/cluster.yml"
        ansible.limit = "#{info[:ip]}" # Ansible hosts are identified by ip
      end

    end

  end

end
