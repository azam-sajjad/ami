#!/bin/bash
# install Ansible and PPA
# install Ansible and PPA
# sudo apt update && sudo apt -y upgrade
# sudo apt -y install software-properties-common
# sudo apt-add-repository -y ppa:ansible/ansible
# sudo add-apt-repository -y ppa:deadsnakes/ppa
# sudo add-apt-repository -y universe
# # sudo apt install python3.8 python3-virtualenv
# # sudo echo "ubuntu ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ubuntu
# sudo apt install ansible -y
# # sudo apt install python3-pip
# # pip3 install ansible
# # virtualenv -p python3.8 venv-ansible
# # source venv-ansible/bin/activate
# # pip install ansible
# # pip freeze
sudo apt -y update && sudo apt -y upgrade
sudo apt -y install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt -y update
sudo apt -y install ansible
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