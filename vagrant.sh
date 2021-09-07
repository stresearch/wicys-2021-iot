#!/bin/bash

export DEBIAN_FRONTEND="noninteractive"

apt-get update -y
sudo apt-get install -y \
dsniff \
jupyter-notebook \
mininet \
openvswitch-switch \
python3-matplotlib \
python3-pip

pip3 install \
altair \
networkx \
nx_altair

sysctl -w net.ipv4.ip_forward=1
service openvswitch-switch start
sed -i 's/nameserver.*/nameserver 8.8.8.8/g' /etc/resolv.conf