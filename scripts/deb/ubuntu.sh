#!/bin/bash
# install Ansible and PPA
sudo apt update && sudo apt -y upgrade
sudo apt -y install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt update && sudo apt -y upgrade
sudo apt install python3.8 python3-virtualenv
pip freeze
virtualenv -p python3.8 venv-ansible
source venv-ansible/bin/activate
pip install ansible
pip freeze
ansible --version
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