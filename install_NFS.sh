#!/bin/bash

#Lieux partage NFS + Réseau client
EXPORT_DIR="/data/nfsshare"
CLIENT_NET="192.168.15.0/24"

# MAJ + Installation des paquets de NFS
apt update && apt upgrade -y
apt install -y nfs-kernel-server

# Création du répertoire de partage
mkdir -p $EXPORT_DIR
chown nobody:nogroup $EXPORT_DIR
chmod 755 $EXPORT_DIR

#Config export NFS
echo "$EXPORT_DIR $CLIENT_NET(rw,sync,no_subtree_check)" > /etc/exports
exportfs -a

# Redémarrage du service NFS
systemctl restart nfs-kernel-server
systemctl enable nfs-kernel-server
# Affichage du statut du service NFS
systemctl status nfs-kernel-server

echo "Installation NFS terminée. Le répertoire $EXPORT_DIR est partagé avec le réseau $CLIENT_NET."