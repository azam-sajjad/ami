#!/bin/bash
# install Ansible and PPA
sudo apt -y update && sudo apt -y upgrade
sudo apt -y install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt update
sudo apt install ansible -y
# sudo apt -y install python3.8 python3-pip
# sudo pip3 --version
# sudo pip3 install ansible
ls -alh ~/
sudo ls -alh /root
pwd
echo $PATH
which ansible
mkdir -p ~/.ansible/collections/ansible_collections
ansible-galaxy collection install ansible.posix
ansible-galaxy collection install community.general
sudo mkdir -p /usr/share/ansible/collections
sudo cp -r /root/.ansible/collections/ansible_collections /usr/share/ansible/collections/
sudo chmod -R a+rx /usr/share/ansible/collections/
# install ssm agent
sudo snap install amazon-ssm-agent --classic
sudo snap start amazon-ssm-agent