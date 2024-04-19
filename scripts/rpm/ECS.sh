#!/bin/bash
# install Ansible & Lynis
sudo yum clean all
sudo yum install ansible -y
sudo amazon-linux-extras install ansible2 -y
sudo yum install lynis -y
ansible-galaxy collection install ansible.posix
ansible-galaxy collection install community.general
sudo mkdir -p /usr/share/ansible/collections
sudo cp -r /root/.ansible/collections/ansible_collections /usr/share/ansible/collections/
sudo chmod -R a+rx /usr/share/ansible/collections/