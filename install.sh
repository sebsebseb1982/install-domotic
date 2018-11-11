#!/usr/bin/env bash

# A sauvegarder
#
# Musique
# clé SSH
# fstab
# configuration
# crons

function echoTitreEtape {
    echo -e "\e[34m=========================================================="
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
        echo -e "$1 \e[32mOK";
    else
        echo -e "$1 \e[31mKO";
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
apt-get update
apt-get upgrade

# ==========================================================
echoTitreEtape "Clé SSH"
# ==========================================================
cp ~/git/install-domotic/ssh/* ~/.ssh/
echoOK

# ==========================================================
echoTitreEtape "Domotic"
# ==========================================================
cd
mkdir git
cd git
git clone

cd domotic2
npm install

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