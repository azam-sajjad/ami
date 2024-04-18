#!/bin/bash
# install Ansible and PPA
sudo apt -y update && sudo apt -y upgrade
sudo apt -y install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt -y update
sudo apt-get install ansible -y
mkdir -p ~/.ansible/roles
mkdir -p ~/.ansible/collections/ansible_collections
sudo chmod -R a+rx ~/.ansible
ansible-galaxy collection install ansible.posix
ansible-galaxy collection install community.general
# install ssm agent
sudo snap install amazon-ssm-agent --classic
sudo snap start amazon-ssm-agent