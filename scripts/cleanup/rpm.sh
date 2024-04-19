#!/bin/bash
# uninstall Ansible
sudo yum remove -y ansible
rm -rf /home/${var.username}/*