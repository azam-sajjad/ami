#!/bin/bash
# install Ansible with Python3.10
sudo apt-get update -y 
sudo apt -y install software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt-get update
PYVER="`python3 --version | awk '{print $2}' | cut -d. -f 2`"
echo "PYVER=$PYVER"
if [[ $PYVER -lt 8 ]]
then
    sudo apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev -y 1> /dev/null
    sudo wget https://www.python.org/ftp/python/3.8.10/Python-3.8.10.tgz 1> /dev/null
    tar -xvf Python-3.8.10.tgz 1> /dev/null
    echo "Python3.10 installation will take 5+ minutes! - IGNORE ./configure ERRORS"
    cd Python-3.8.10
    sudo ./configure --enable-optimizations 1> /dev/null
    sudo make -j $(nproc) 1> /dev/null
    sudo make altinstall 1> /dev/null
    cd ..
    /usr/bin/python3.10 -m pip install --upgrade pip
    /usr/bin/python3.10 -m pip install ansible
    ansible --version
    ansible-community --version
else
    sudo apt install ansible -y
    # /usr/bin/python3.10 -m pip install --upgrade pip
    # /usr/bin/python3.10 -m pip install ansible
    # sudo apt-get install -y ansible
    ansible --version
    ansible-community --version
fi
# install ssm agent
sudo snap install amazon-ssm-agent --classic
sudo snap start amazon-ssm-agent