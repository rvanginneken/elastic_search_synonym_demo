#!/bin/bash

# Docker

wget -qO - https://download.docker.com/linux/debian/gpg | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add -

echo "deb https://download.docker.com/linux/debian $(lsb_release -sc) stable" > /etc/apt/sources.list.d/docker.list

apt-get update

apt-get install -y docker-ce docker-ce-cli containerd.io

systemctl enable docker

# Allow docker for vagrant user
usermod -a -G docker vagrant

# If you want to use swarm, start a cluster
# docker swarm init --advertise-addr 127.0.0.1

