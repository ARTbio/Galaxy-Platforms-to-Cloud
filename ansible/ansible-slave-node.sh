#!/usr/bin/env bash
# as root

apt-get update 
apt-get install -y git
apt-get install -y software-properties-common
apt-add-repository -y ppa:ansible/ansible
apt-get update
apt-get install -y ansible
git clone https://github.com/ARTbio/ansible-galaxy-extras.git --branch PtC
cd ansible-galaxy-extras
ansible-playbook -i localhost, local.yml -e @defaults/main.yml -vvv
