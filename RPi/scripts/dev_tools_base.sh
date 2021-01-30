#!/bin/bash -eu

apt-get update
apt-get upgrade -y

apt-get install -y apt-transport-https ca-certificates gnupg software-properties-common wget build-essential

apt-get update

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

cd /tmp
mkdir cmake
cd cmake
wget https://cmake.org/files/v3.19/cmake-3.19.4.tar.gz
tar -xvzf cmake-3.19.4.tar.gz
cd cmake-3.19.4/
sudo ./bootstrap
sudo make
sudo make install
