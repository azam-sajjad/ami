#!/bin/bash
# install Ansible and PPA
sudo apt update && sudo apt -y upgrade
sudo apt -y install software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt -y update 
sudo apt-get upgrade -y
python3
sudo apt install python3-pip -y
sudo apt install python3-virtualenv
virtualenv -p python3 venv-ansible
source venv-ansible/bin/activate
pip list
pip install ansible
ansible --version
# install ssm agent
sudo snap install amazon-ssm-agent --classic
sudo snap start amazon-ssm-agent