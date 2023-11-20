#!/bin/bash -eu

if [ $INSTALL_RPI_PACKER_TOOLS = "true" ]
then

    snap install go --classic

    apt install -yq git
    apt install -yq unzip
    apt install -yq qemu-user-static
    apt install -yq e2fsprogs
    apt install -yq dosfstools
    apt install -yq libarchive-tools
    apt install -yq nfs-common
    apt install -yq parted
    apt install -yq e2fsprogs
    apt install -yq qemu-utils

    cd /tmp
    wget https://releases.hashicorp.com/packer/1.9.4/packer_1.9.4_linux_amd64.zip
    unzip packer_1.9.4_linux_amd64.zip
    mv packer /usr/local/bin/

    #   Switch to the development user

    sudo -i -u $DEV_USERNAME

    cd /home/$DEV_USERNAME
    sudo -u $DEV_USERNAME git clone https://github.com/mkaczanowski/packer-builder-arm
    cd /home/$DEV_USERNAME/packer-builder-arm
    sudo -u $DEV_USERNAME go mod download
    sudo -u $DEV_USERNAME go build

    cd /tmp
    sudo -u $DEV_USERNAME git clone https://github.com/stephanfr/Packer.git
    sudo -u $DEV_USERNAME rsync -a /tmp/Packer/RPi/ /home/$DEV_USERNAME/packer-builder-arm/

fi
