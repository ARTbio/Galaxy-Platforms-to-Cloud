#!/usr/bin/env bash
# as root

git clone https://github.com/ARTbio/ansible-galaxy-extras.git --branch PtC
cd ansible-galaxy-extras
ansible-playbook -i localhost, local.yml -e @defaults/main.yml
