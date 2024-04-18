#!/bin/bash
# install Ansible & Lynis
sudo yum clean all
sudo yum install ansible -y
sudo amazon-linux-extras install ansible2 -y
sudo yum install lynis -y
ansible-galaxy collection install ansible.posix
ansible-galaxy collection install community.general