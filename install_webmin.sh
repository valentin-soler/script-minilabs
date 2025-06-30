#!/bin/bash

# Repo install
apt install curl
curl -o webmin-setup-repo.sh https://raw.githubusercontent.com/webmin/webmin/master/webmin-setup-repo.sh
sh webmin-setup-repo.sh
apt install webmin --install-recommends

echo "Webmin : ip:10000"