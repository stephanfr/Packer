#!/bin/bash -eu

snap install go --classic

apt-get install -yq git
apt-get install -yq unzip
apt-get install -yq qemu-user-static
apt-get install -yq e2fsprogs
apt-get install -yq dosfstools
apt-get install -yq libarchive-tools
apt-get install -yq nfs-common
apt-get install -yq parted
apt-get install -yq e2fsprogs
apt-get install -yq qemu-utils

cd /tmp
wget https://releases.hashicorp.com/packer/1.6.6/packer_1.6.6_linux_amd64.zip
unzip packer_1.6.6_linux_amd64.zip
mv packer /usr/local/bin/

cd /home/$DEV_USERNAME
sudo -u $DEV_USERNAME git clone https://github.com/mkaczanowski/packer-builder-arm
cd /home/$DEV_USERNAME/packer-builder-arm
sudo -u $DEV_USERNAME go mod download
sudo -u $DEV_USERNAME go build

cd /tmp
git clone https://github.com/stephanfr/Packer.git
rsync -a /tmp/Packer/RPi/ /home/$DEV_USERNAME/packer-builder-arm/

