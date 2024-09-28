#!/bin/bash -eu

if [ $INSTALL_DEV_TOOLS_BASE = "true" ]
then

    apt update
    apt upgrade -y

    apt install -y apt-transport-https ca-certificates gnupg software-properties-common wget build-essential

    apt-add-repository "deb https://apt.kitware.com/ubuntu/ $UBUNTU_BUILD_NAME main"
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null

    wget -O - https://download.docker.com/linux/ubuntu/gpg 2>/dev/null | gpg --dearmor - | sudo tee /etc/apt/trusted.gpg.d/docker.gpg >/dev/null
    apt-add-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $UBUNTU_BUILD_NAME stable"

    apt update -y

    apt-cache policy docker-ce

    apt install -y docker-ce
    groupadd docker

    apt install -y build-essential linux-headers-$(uname -r)

    if [ $VIRTUALBOX = "true" ]
    then
    apt install -y virtualbox-guest-x11
    apt install -y virtualbox-guest-utils
    apt install -y virtualbox-guest-dkms
    fi

    apt install -y net-tools
    apt install -y cmake
    apt install -y curl
    apt install -y python3
    apt install -y python3-dev
    apt install -y python3-pip
    apt install -y libtool
    apt install -y autoconf
    apt install -y automake
    apt install -y autotools-dev
    apt install -y git
    apt install -y clang
    apt install -y clang-format
    apt install -y clang-tidy
    apt install -y lcov
    apt install -y npm
    apt install -y wxhexeditor
    apt install -y doxygen
    apt install -y mtools

    python3 -m pip install virtualenv

    if [ $INSTALL_MINIKUBE = "true" ]
    then
        cd /tmp
        wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
        cp minikube-linux-amd64 /usr/local/bin/minikube
        chmod 755 /usr/local/bin/minikube

        curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
        echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
        apt update -y
        apt install -y kubectl
        ln -s /bin/kubectl /usr/local/bin/kubectl

        curl https://baltocdn.com/helm/signing.asc | apt-key add -
        echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list
        apt update
        apt install helm

        wget -O helmfile_linux_amd64 https://github.com/roboll/helmfile/releases/download/v0.105.0/helmfile_linux_amd64
        chmod +x helmfile_linux_amd64
        cp helmfile_linux_amd64 /usr/local/bin/.
        ln -s /usr/local/bin/helmfile_linux_amd64 /usr/local/bin/helmfile
    fi
fi