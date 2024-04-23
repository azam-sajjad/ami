#!/bin/bash
# install Ansible and PPA
echo "127.0.0.1 `hostname` localhost" >> /etc/hosts
sudo apt -y update 
sudo apt-get upgrade -y
# sudo apt -y install software-properties-common
# sudo apt-add-repository --yes --update ppa:ansible/ansible
# sudo apt-get update --fix-missing -y
# sudo apt -y install ansible
# ansible --version
python3 -m pip install --upgrade pip
python3 -m pip install ansible
ansible --version
echo $PATH
which ansible
which python3
python3
ansible --version
ansible-galaxy collection install community.general
ansible-galaxy collection install ansible.posix
sudo mkdir -p /usr/share/ansible/collections
sudo cp -r /root/.ansible/collections/ansible_collections /usr/share/ansible/collections/
sudo chmod -R a+rx /usr/share/ansible/collections/
# install ssm agent
mkdir /tmp/ssm
cd /tmp/ssm
wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
sudo dpkg -i amazon-ssm-agent.deb
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent