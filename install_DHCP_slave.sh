#!/bin/bash

apt update && apt upgrade -y
apt install -y isc-dhcp-server

cat > /etc/dhcp/dhcpd.conf << EOF
option domain-name "linuxisgood.local";
option domain-name-servers 192.168.15.253, 192.168.15.252;

default-lease-time 600;
max-lease-time 7200;

authoritative;

subnet 192.168.15.0 netmask 255.255.255.0 {
    range 192.168.15.100 192.168.15.150;
    option routers 192.168.15.254;
    option domain-name-servers 192.168.15.253, 192.168.15.252;
    option domain-name "linuxisgood.local";
}

failover peer "dhcp-failover" {
    secondary;
    address 192.168.15.252;
    port 847;
    peer address 192.168.15.253
    peer port 647;
    max-response-delay 60;
    max-unacked-updates 10;
    load balance max seconds 3;
}
EOF

echo 'INTERFACEv4="ens33"' > /etc/default/isc-dhcp-server

systemctl restart isc-dhcp-server
systemctl enable isc-dhcp-server