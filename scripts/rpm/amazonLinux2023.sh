#!/bin/bash
# install Ansible
sudo yum clean all
sudo dnf config-manager --set-enabled crb
sudo dnf install epel-release epel-next-release
sudo yum-config-manager --enable epel
sudo yum install ansible -y
ansible-galaxy collection install ansible.posix
ansible-galaxy collection install community.general
sudo mkdir -p /usr/share/ansible/collections
sudo cp -r /root/.ansible/collections/ansible_collections /usr/share/ansible/collections/
sudo chmod -R a+rx /usr/share/ansible/collections/