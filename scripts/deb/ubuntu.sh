#!/bin/bash
# install Ansible with Python3.10
sudo apt-get update -y 
sudo apt -y install software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt-get update
PYVER="`python3 --version | awk '{print $2}' | cut -d. -f 2`"
echo "================= Python 3 Version Detected = 3.$PYVER ======================="
if [[ $PYVER -lt 8 ]]
then
    sudo apt-get install build-essential zlib1g-dev libncurses5-dev libncursesw5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget curl libbz2-dev xz-utils tk-dev liblzma-dev python3-openssl -y 1> /dev/null
    sudo wget https://www.python.org/ftp/python/3.10.4/Python-3.10.4.tgz 1> /dev/null
    tar -xvf Python-3.10.4.tgz 1> /dev/null
    echo "================= Need to Install Python 3.8 for Ansible ======================="
    echo "Python-3.10 installation will take 5+ minutes! - IGNORE ./configure ERRORS"
    cd Python-3.10.4
    sudo ./configure --enable-optimizations 1> /dev/null
    sudo make -j $(nproc) 1> /dev/null
    sudo make altinstall 1> /dev/null
    cd ..
    which python3.10
    /usr/local/bin/python3.10 -u ubuntu -m pip install --upgrade pip
    /usr/local/bin/python3.10 -u ubuntu -m pip install ansible 
    ls -alh /home/ubuntu
    ls -alh /home/ubuntu/.ansible
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