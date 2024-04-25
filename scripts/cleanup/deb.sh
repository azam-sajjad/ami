#!/bin/bash
# uninstall Ansible and Remove PPA
df -h
sudo lynis audit system --pentest
sudo apt -y remove --purge ansible
sudo apt-add-repository --remove ppa:ansible/ansible
if [[ $(cat /etc/os-release | grep ^ID | cut -d= -f 2) == "debian" ]]; then
    sudo sed -i '$ d' /etc/hosts
fi
sudo apt -y autoremove