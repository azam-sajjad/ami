#!/bin/bash
# uninstall Ansible and Remove PPA
sudo apt -y remove --purge ansible
sudo apt-add-repository --remove ppa:ansible/ansible
sudo apt -y autoremove