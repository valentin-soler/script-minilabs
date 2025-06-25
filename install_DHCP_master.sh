#!/bin/bash

apt update && apt upgrade -y
apt install -y isc-dhcp-server

# Configuration du serveur DHCP
cat > /etc/dhcp/dhcpd.conf <<EOF
option domain-name "linuxisgood.local";
option domain-name-servers 192.168.15.253, 192.168.15.252;

default-lease-time 600;
max-lease-time 7200;

authoritative;

subnet 192.168.15.0 netmask 255.255.255.0 {
    range 192.168.15.100 192.168.15.150;
    option routers 192.168.15.254;
    option domain-name-servers 192.168.15.253 192.168.15.252;
    option domain-name "linuxisgood.local";
}

#Failover
failover peer "dhcp-failover" {
    primary;
    address 192.168.15.253;
    port 647;
    peer address 192.168.15.252;
    peer port 847;
    max-response-delay 60;
    max-unacked-update 10;
    mclt 300;
    split 128;
    load balance max seconds 3;
}
EOF

echo 'INTERFACESv4="eth0"' > /etc/default/isc-dhcp-server

systemctl restart isc-dhcp-server
systemctl enable isc-dhcp-server

echo "DHCP Master configuré."