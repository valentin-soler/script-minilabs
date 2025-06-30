#!/bin/bash

apt update && apt upgrade
apt install bind9

cat > "/etc/bind/named.conf.local" <<EOF
forwarders {
    1.1.1.1; // Cloudflare DNS
}
recursion yes;

zone "linuxisgood.local" {
    type master;
    file "/etc/bind/zones/db.linuxisgood.local";
    allow-transfer { 192.168.15.252; };
};
EOF

mkdir -p /etc/bind/zones

cat > /etc/bind/zones/db.linuxisgood.local <<EOF
\$TTL 604800
@ IN SOA ns1.linuxisgood.local. admin.linuxisgood.local. (
    2024062501 ; Serial
    604800 ; Refresh
    86400 ; Retry
    2419200 ; Expire
    604800 ) ; Negative Cache TTL

@ IN NS ns1.linuxisgood.local.
ns1 IN A 192.168.15.253
@ IN A 192.168.15.254
EOF

systemctl restart bind9
systemctl enable bind9