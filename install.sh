#!/usr/bin/env bash

# A sauvegarder
#
# Musique
# clé SSH
# fstab
# configuration
# crons

function echoTitreEtape {
    echo -e "\e[32m=========================================================="
    echo $1
    echo -e "==========================================================\e[39m"
}

function echoOK {
    echo -e "\e[32mOK\e[39m"
}

# ==========================================================
echoTitreEtape "Mettre à jour mot de passe par défaut ?"
# ==========================================================
select yn in "Yes" "No"; do
    case $yn in
        Yes ) passwd; break;;
        No ) break;;
    esac
done

# ==========================================================
echoTitreEtape "Vérification prérequis"
# ==========================================================
function verifierPreRequis {
    if [ -f "/home/pi/git/install-domotic/$1" ];then
        echo -e "$1 \e[32mOK\e[39m";
    else
        echo -e "$1 \e[31mKO\e[39m";
        exit 1
    fi
}

verifierPreRequis "crontab/crontab-user-root.txt"
verifierPreRequis "crontab/crontab-user-pi.txt"
verifierPreRequis "fstab/fstab.txt"
verifierPreRequis "configuration/configuration.ts"
verifierPreRequis "ssh/id_rsa"
verifierPreRequis "ssh/id_rsa.pub"

# ==========================================================
echoTitreEtape "MAJ Système"
# ==========================================================
sudo apt-get -y update
sudo apt-get -y upgrade

# ==========================================================
echoTitreEtape "Installation paquets de base"
# ==========================================================
curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -
sudo apt-get install -y nodejs
# Nécessaire pour que le npm install de la domotique se passe correctement
sudo apt-get install -y libavahi-compat-libdnssd-dev

# ==========================================================
echoTitreEtape "Clé SSH"
# ==========================================================
mkdir -p ~/.ssh
sudo cp ~/git/install-domotic/ssh/* ~/.ssh/
echoOK

# ==========================================================
echoTitreEtape "Domotic"
# ==========================================================
sudo npm install -g typescript
cd ~/git
git clone git@github.com:sebsebseb1982/domotic2.git

mv install-domotic/configuration/configuration.ts domotic2/src/configuration/

cd domotic2
npm install
tsc

# ==========================================================
echoTitreEtape "Wiring Pi"
# ==========================================================
cd ~/git
git clone git://git.drogon.net/wiringPi
cd wiringPi
./build

# ==========================================================
echoTitreEtape "Montages fstab"
# ==========================================================
sudo cat ~/git/install-domotic/fstab/fstab.txt >> /etc/fstab
echoOK

# ==========================================================
echoTitreEtape "Installation des cron pi & root"
# ==========================================================
crontab ~/git/install-domotic/crontab/crontab-user-pi.txt
sudo crontab ~/git/install-domotic/crontab/crontab-user-root.txt
echoOK

exit 0