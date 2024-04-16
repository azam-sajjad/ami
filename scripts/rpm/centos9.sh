#!/bin/bash
# install Ansible
sudo dnf config-manager --set-enabled crb
sudo dnf install epel-release epel-next-release
# sudo yum -y update
sudo yum-config-manager --enable epel
sudo yum install lynis -y
sudo yum clean all
sudo yum install ansible-core -y
ansible-galaxy collection install ansible.posix
ansible-galaxy collection install community.general
sudo mkdir -p /usr/share/ansible/collections
sudo cp -r /root/.ansible/collections/ansible_collections /usr/share/ansible/collections/
sudo chmod -R a+rx /usr/share/ansible/collections/