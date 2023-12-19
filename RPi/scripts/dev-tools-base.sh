#!/bin/bash -eu

apt-get update
apt-get upgrade -y

apt-get install -y apt-transport-https
apt-get install -y ca-certificates
apt-get install -y gnupg
apt-get install -y software-properties-common

apt-get update

apt-get install -y git

apt-get install -y wget
apt-get install -y build-essential
apt-get install -y openssl
apt-get install -y libssl-dev
apt-get install -y curl
apt-get install -y libtool
apt-get install -y autoconf
apt-get install -y automake
apt-get install -y clang
apt-get install -y clang-format
apt-get install -y clang-tidy

apt-get install -y python3
apt-get install -y python3-dev
apt-get install -y python3-pip

apt-get install -y gpiod
apt-get install -y libgpiod-dev


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

