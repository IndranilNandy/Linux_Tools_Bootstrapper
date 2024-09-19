#!/bin/bash

sudo apt --fix-broken install -y
[[ -n $(which git) ]] || (sudo apt update && (yes | sudo apt install git))

dpkg-query -l gcm > /dev/null && echo -e "GCM is already installed and configured" || ./gcm_installer.sh
