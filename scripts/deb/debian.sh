#!/bin/bash
# install Ansible with Python3.10 Virtual Environment
sudo apt-get update -y 1> /dev/null
sudo apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev -y 1> /dev/null
sudo wget https://www.python.org/ftp/python/3.10.4/Python-3.10.4.tgz 1> /dev/null
tar -xvf Python-3.10.4.tgz 1> /dev/null
echo "Python3.10 installation will take 5+ minutes! - IGNORE ./configure ERRORS"
cd Python-3.10.4
sudo ./configure --enable-optimizations 1> /dev/null
sudo make -j $(nproc) 1> /dev/null
sudo make altinstall 1> /dev/null
cd ..
/usr/local/bin/python3.10 -m pip install --upgrade pip
/usr/local/bin/python3.10 -m pip install ansible
ansible --version
ansible-community --version
# install ssm agent
mkdir /tmp/ssm
cd /tmp/ssm
wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb 1> /dev/null
sudo dpkg -i amazon-ssm-agent.deb
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent