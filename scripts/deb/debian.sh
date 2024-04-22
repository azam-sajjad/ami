#!/bin/bash
# install Ansible and PPA
sudo apt -y update
# sudo apt -y install software-properties-common
# sudo apt-add-repository ppa:ansible/ansible
# sudo apt -y update
sudo apt-get -y install ansible
# sudo apt-get install python3 python3-pip -y
ansible --version
which ansible
sudo ls -alh /root/.ansible/collections
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