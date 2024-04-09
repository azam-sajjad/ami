#!/bin/bash
# uninstall Ansible and Remove PPA
sudo apt -y remove --purge ansible
sudo apt-add-repository --remove ppa:ansible/ansible
# Apt Cleanup
sudo apt -y autoremove
sudo apt -y update