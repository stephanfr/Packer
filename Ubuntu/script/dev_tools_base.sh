#!/bin/bash -eu

apt-get update
apt-get upgrade -y

apt-get install -y apt-transport-https ca-certificates gnupg software-properties-common wget build-essential

apt-add-repository "deb https://apt.kitware.com/ubuntu/ $UBUNTU_BUILD_NAME main"
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null

wget -O - https://download.docker.com/linux/ubuntu/gpg 2>/dev/null | gpg --dearmor - | sudo tee /etc/apt/trusted.gpg.d/docker.gpg >/dev/null
apt-add-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $UBUNTU_BUILD_NAME stable"

apt-get update

apt-cache policy docker-ce

apt-get install -y docker-ce
groupadd docker

apt-get install -y cmake
apt-get install -y curl
apt-get install -y python3
apt-get install -y python3-dev
apt-get install -y python3-pip
apt-get install -y libtool
apt-get install -y autoconf
apt-get install -y automake
apt-get install -y git
apt-get install -y clang
apt-get install -y clang-format


