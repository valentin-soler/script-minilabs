#!/bin/bash

apt update && apt upgrade -y
apt install -y isc-dhcp-server

cat > /etc/dhcp/dhcpd.conf << EOF
option domain-name "linuxisgood.local";
option domain-name-servers 192.168.15.253, 192.168.15.252;