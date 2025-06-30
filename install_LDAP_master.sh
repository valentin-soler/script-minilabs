#!/bin/bash
PSWD_REPLICATOR= $(tr -dc 'A-Za-z0-9!@#$%^&*()_+=' < /dev/urandom | head -c12 ; echo)
IP="192.168.15.254"
#Installation de LDAP et phpLDAPadmin pour facilité l'administration

apt update && apt upgrade

apt install -y slapd ldap-utils

dpkg-reconfigure slapd

ldapadd -y EXTERNAL -h ldapi:// <<EOF
dn: cd=replicator,dc=linuxisgood,dc=local
objectClass: simpleSecurityObject
objectClass: organizationalRole
cn : replicator
userPassword: $PSWD_REPLICATOR
description: Replication user
EOF

apt install apache2 php php-ldap php-xml php-mbstring php-json php-mysql php-curl php-gd php-intl php-zip php-bz2 php-imap php-apcu -y
apt install phpldapadmin -y

echo "Le mot de passe de l'utilisateur de réplication est $PSWD_REPLICATOR "
echo "Vous pouvez accédé a phpLDAPadmin sur l'adresse : http://$IP/phpLDAPadmin