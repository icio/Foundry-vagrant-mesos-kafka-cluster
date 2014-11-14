#!/bin/bash 

sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible

git clone https://github.com/Woorank/vagrant-mesos-cluster.git /home/ubuntu/vagrant-mesos-cluster

# disable known_hosts checking
sed -i 's/^#host_key_checking = False$/host_key_checking = False/g' /etc/ansible/ansible.cfg
