#!/bin/bash -eu

apt-get update
apt-get upgrade -y

apt-get install -y apt-transport-https ca-certificates gnupg software-properties-common wget build-essential

apt-add-repository "deb https://apt.kitware.com/ubuntu/ $UBUNTU_BUILD_NAME main"
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null

wget -O - https://download.docker.com/linux/ubuntu/gpg 2>/dev/null | gpg --dearmor - | sudo tee /etc/apt/trusted.gpg.d/docker.gpg >/dev/null
apt-add-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $UBUNTU_BUILD_NAME stable"

apt-get update -y

apt-cache policy docker-ce

apt-get install -y docker-ce
groupadd docker

apt-get install -y build-essential linux-headers-$(uname -r)

if [ $VIRTUALBOX = "true" ]
then
apt-get install -y virtualbox-guest-x11
apt-get install -y virtualbox-guest-utils
apt-get install -y virtualbox-guest-dkms
fi

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
apt-get install -y clang-tidy
apt-get install -y lcov
apt-get install -y npm

python3 -m pip install virtualenv

if [ $INSTALL_MINIKUBE = "true" ]
then
    cd /tmp
    wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    cp minikube-linux-amd64 /usr/local/bin/minikube
    chmod 755 /usr/local/bin/minikube

    curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
    apt-get update -y
    apt-get install -y kubectl
    ln -s /bin/kubectl /usr/local/bin/kubectl

    curl https://baltocdn.com/helm/signing.asc | apt-key add -
    echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list
    apt-get update
    apt-get install helm

    wget -O helmfile_linux_amd64 https://github.com/roboll/helmfile/releases/download/v0.105.0/helmfile_linux_amd64
    chmod +x helmfile_linux_amd64
    cp helmfile_linux_amd64 /usr/local/bin/.
    ln -s /usr/local/bin/helmfile_linux_amd64 /usr/local/bin/helmfile
fi