#!/bin/bash
# install Ansible and PPA
echo "127.0.0.1 `hostname` localhost" >> /etc/hosts
sudo apt update
sudo apt -y install software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev
wget https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tgz
tar -xvf Python-3.10.0.tgz
cd Python-3.10.0
sudo ./configure --enable-optimizations
make -j $(nproc)
sudo make altinstall
sudo apt -y update 
sudo apt-get upgrade -y
python3.10 --version
pip3.10 install --user --upgrade pip
python3
sudo apt install python3-pip -y
sudo apt install python3-virtualenv -y
virtualenv -p python3 venv-ansible
# python3.10 -m venv venv-ansible
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