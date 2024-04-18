#!/bin/bash
# install Ansible and PPA
sudo apt -y update && sudo apt -y upgrade
sudo apt -y install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt update
sudo apt install ansible
# sudo apt -y install python3.8 python3-pip
# sudo pip3 --version
# sudo pip3 install ansible
echo $PATH
which ansible
mkdir -p ~/.ansible/roles
mkdir -p ~/.ansible/collections/ansible_collections
ansible-galaxy collection install ansible.posix
ansible-galaxy collection install community.general
# install ssm agent
sudo snap install amazon-ssm-agent --classic
sudo snap start amazon-ssm-agent