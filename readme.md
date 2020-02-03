# Installation de la domotique

## Lancement de l'installation
'''ansible-playbook install-domotic.yml -i domotic.ini'''

## Etapes manuelles

### Activation SSH sur le RaspberryPi

### Installation de la clé SSH Hote -> RaspberryPi 
https://pimylifeup.com/raspberry-pi-ssh-keys/
ssh-keygen
ssh-copy-id -i ~/.ssh/id_rsa pi@IP_ADDRESS

### Installation de la clé RaspberryPi -> Github