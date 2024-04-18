#!/bin/bash
# install Ansible & Lynis
sudo yum clean all
sudo yum config-manager --set-enabled crb
sudo yum install epel-release epel-next-release
sudo yum-config-manager --enable epel
sudo yum install ansible -y
sudo yum install ansible-core -y
echo $PATH
which ansible
ansible-galaxy collection install ansible.posix
ansible-galaxy collection install community.general
sudo mkdir -p /usr/share/ansible/collections
sudo cp -r /root/.ansible/collections/ansible_collections /usr/share/ansible/collections/
sudo chmod -R a+rx /usr/share/ansible/collections/
# install ssm agent
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable --now amazon-ssm-agent