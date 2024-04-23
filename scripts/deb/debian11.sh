#!/bin/bash
# install Ansible and PPA
echo "127.0.0.1 `hostname` localhost" >> /etc/hosts
sudo apt update
sudo apt -y install software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo add-apt-repository -y universe
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
ansible-community --version
# install ssm agent
mkdir /tmp/ssm
cd /tmp/ssm
wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
sudo dpkg -i amazon-ssm-agent.deb
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent