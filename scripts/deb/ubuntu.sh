#!/bin/bash
# install Ansible with Python3.10
sudo apt-get update -y 
sudo apt -y install software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt update
sudo apt-get update
PYVER="`python3 --version | awk '{print $2}' | cut -d. -f 2`"
echo "================= Python 3 Version Detected = 3.$PYVER ======================="
if [[ $PYVER -lt 8 ]]
then
    echo "================= Setting up Python 3.8 for Ansible ======================="
    pip --version
    sudo apt install python3.8 -y
    sudo apt install python3.8-dev python3.8-venv -y
    sudo apt install python3-pip python3-setuptools python3-wheel --yes --quiet
    sudo apt install ansible -y
    ansible-galaxy collection install ansible.posix
    ansible-galaxy collection install community.general
    sudo mkdir -p /usr/share/ansible/collections
    sudo cp -r /root/.ansible/collections/ansible_collections /usr/share/ansible/collections/
    sudo chmod -R a+rx /usr/share/ansible/collections/
    ansible --version
    ansible-community --version
else
    sudo apt install ansible -y
    ansible --version
    ansible-community --version
fi
# install ssm agent
sudo snap install amazon-ssm-agent --classic
sudo snap start amazon-ssm-agent
sudo systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent.service