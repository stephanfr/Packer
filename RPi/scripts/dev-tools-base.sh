#!/bin/bash -eu

apt update
apt upgrade -y

apt install -y apt-transport-https
apt install -y ca-certificates
apt install -y gnupg
apt install -y software-properties-common

apt update

apt install -y git

apt install -y wget
apt install -y build-essential
apt install -y openssl
apt install -y libssl-dev
apt install -y curl
apt install -y libtool
apt install -y autoconf
apt install -y automake
apt install -y clang
apt install -y clang-format
apt install -y clang-tidy

apt install -y python3
apt install -y python3-dev
apt install -y python3-pip
apt install -y python3-distutils

apt install -y gpiod
apt install -y libgpiod-dev


if [ "$CPU_ARCH" == "ARMHF" ]; then
    export CFLAGS="-D_FILE_OFFSET_BITS=64"
    export CXXFLAGS="-D_FILE_OFFSET_BITS=64"
fi

#
#   Make CMake.  The raspbian repos have old versions and we need at least 3.16 for VS Code
#       This will run a parallel make assuming 3 cores.  If more are available, bump
#       up the value of CMAKE_BUILD_PARALLEL_LEVEL, --parallel and -j to a value
#       of the number of cores + 1.
#   
#   Be advised, on a fast x-86 processor, building CMake under qemu-user can take an hour or two.
#

cd /tmp
mkdir cmake
cd cmake
wget ${CMAKE_URL}
tar -xzf ${CMAKE_VERSION}.tar.gz
cd ${CMAKE_VERSION}/

export CMAKE_BUILD_PARALLEL_LEVEL=3

./bootstrap --parallel=3
make -j3
make install


#
#   Build the pigpio library
#

if [ ! -z "$PIGPIO_URL" ]; then

    cd /tmp
    mkdir pigpio
    cd pigpio
    wget ${PIGPIO_URL}
    unzip master.zip
    cd pigpio-master
    make -j3
    make install
    
fi


#
#   Google Test and Google Mock
#

if [ ! -z "$GOOGLETEST_URL" ]; then

    cd /tmp
    git clone ${GOOGLETEST_URL}
    cd googletest
    mkdir build
    cd build
    cmake ..
    make
    make install    # Install in /usr/local/ by default
    
fi


#
#   Finally, Catch2 - I prefer it to GoogleTest in general
#

if [ ! -z "$CATCH2_URL" ]; then

    cd /tmp
    git clone ${CATCH2_URL}
    cd Catch2
    cmake -Bbuild -H. -DBUILD_TESTING=OFF
    cmake --build build/ --target install

fi


