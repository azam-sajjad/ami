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
    # sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.$PYVER 1
    # sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 2
    # sudo update-alternatives --config python3 | 2
    # sudo apt-get install build-essential zlib1g-dev libncurses5-dev libncursesw5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget curl libbz2-dev xz-utils tk-dev liblzma-dev python3-openssl -y 1> /dev/null
    # sudo wget https://www.python.org/ftp/python/3.10.4/Python-3.10.4.tgz 1> /dev/null
    # tar -xvf Python-3.10.4.tgz 1> /dev/null
    # echo "Python-3.10 installation will take 5+ minutes! - IGNORE ./configure ERRORS"
    # cd Python-3.10.4
    # sudo ./configure --enable-optimizations 1> /dev/null
    # sudo make -j $(nproc) 1> /dev/null
    # sudo make altinstall 1> /dev/null
    # cd ..
    sudo apt install python3-pip python3-setuptools python3-wheel --yes --quiet
    which python3.8
    export ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python3.8
    sudo apt install ansible -y
    export ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python3.8
    ansible --version
    ansible-community --version
    # python3.8 -m pip install --upgrade pip
    # python3.8 -m pip install ansible
    # export PATH="$PATH:$HOME/.local/bin:$HOME/bin"
    # which ansible-playbook
    # echo $PATH
    # sudo echo $PATH
    # ansible --version
    # ansible-community --version
    # ansible localhost -m ping
    # sudo mv -r /home/ubuntu/.local/bin/ansible /usr/bin/ansible
    ansible --version
    ansible localhost -m ping
else
    sudo apt install ansible -y
    ansible --version
    ansible-community --version
fi
# install ssm agent
sudo snap install amazon-ssm-agent --classic
sudo snap start amazon-ssm-agent
sudo systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent.service