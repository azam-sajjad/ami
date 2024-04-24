#!/bin/bash
# install Ansible with Python3.10
echo "127.0.0.1 `hostname` localhost" >> /etc/hosts
sudo apt-get update -y 
PYVER="`python3 --version | awk '{print $2}' | cut -d. -f 2`"
echo $PYVER
if [[ $PYVER -lt 10 ]]
then
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
else
    sudo apt -y install software-properties-common
    sudo apt-add-repository -y ppa:ansible/ansible
    sudo apt install -y ansible
    ansible --version
    ansible-community --version
fi

# install ssm agent
mkdir /tmp/ssm
cd /tmp/ssm
wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb 1> /dev/null
sudo dpkg -i amazon-ssm-agent.deb
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent