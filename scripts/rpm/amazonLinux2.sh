#!/bin/bash
# install Ansible
sudo yum -y update && sudo yum -y upgrade
sudo yum install ansible -y
sudo amazon-linux-extras install ansible2 -y
ansible-galaxy collection install ansible.posix
ansible-galaxy collection install community.general
sudo mkdir -p /usr/share/ansible/collections
sudo cp -r /root/.ansible/collections/ansible_collections /usr/share/ansible/collections/
sudo chmod -R a+rx /usr/share/ansible/collections/