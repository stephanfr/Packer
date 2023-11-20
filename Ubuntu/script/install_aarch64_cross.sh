#!/bin/bash -eu

if [ $INSTALL_AARCH64_CROSS = "true" ]
then

    #   Install the qemu aarch64 emulator

    sudo apt install -y qemu-system-aarch64

    #   Install the ARM AARCH64 Cros compiling toolchain

    ARM_TOOLCHAIN_VERSION=12.3.rel1
    ARM_TOOLCHAIN_NAME=arm-gnu-toolchain-$ARM_TOOLCHAIN_VERSION-x86_64-aarch64-none-elf

    sudo -u $DEV_USERNAME mkdir /home/$DEV_USERNAME/dev_tools

    sudo -u $DEV_USERNAME wget https://developer.arm.com/-/media/Files/downloads/gnu/$ARM_TOOLCHAIN_VERSION/binrel/$ARM_TOOLCHAIN_NAME.tar.xz -O /tmp/$ARM_TOOLCHAIN_NAME.tar.xz

    sudo -u $DEV_USERNAME tar xf /tmp/$ARM_TOOLCHAIN_NAME.tar.xz -C /home/$DEV_USERNAME/dev_tools

    sudo -u $DEV_USERNAME mkdir -p /home/$DEV_USERNAME/dev/gcc-cross/aarch64-none-elf/lib

    sudo -u $DEV_USERNAME cp -r /home/$DEV_USERNAME/dev_tools/$ARM_TOOLCHAIN_NAME/lib/gcc /home/$DEV_USERNAME/dev/gcc-cross/aarch64-none-elf/lib/

    sudo -u $DEV_USERNAME mkdir -p /home/$DEV_USERNAME/dev/gcc-cross/aarch64-none-elf/aarch64-none-elf/include/bits

    sudo -u $DEV_USERNAME cp /home/$DEV_USERNAME/dev_tools/$ARM_TOOLCHAIN_NAME/aarch64-none-elf/include/c++/12.3.1/cstdarg /home/$DEV_USERNAME/dev/gcc-cross/aarch64-none-elf/aarch64-none-elf/include/.
    sudo -u $DEV_USERNAME cp /home/$DEV_USERNAME/dev_tools/$ARM_TOOLCHAIN_NAME/aarch64-none-elf/include/c++/12.3.1/cstddef /home/$DEV_USERNAME/dev/gcc-cross/aarch64-none-elf/aarch64-none-elf/include/.

    sudo -u $DEV_USERNAME cp /home/$DEV_USERNAME/dev_tools/$ARM_TOOLCHAIN_NAME/aarch64-none-elf/include/c++/12.3.1/aarch64-none-elf/bits/c++config.h /home/$DEV_USERNAME/dev/gcc-cross/aarch64-none-elf/aarch64-none-elf/include/bits/.
    sudo -u $DEV_USERNAME cp /home/$DEV_USERNAME/dev_tools/$ARM_TOOLCHAIN_NAME/aarch64-none-elf/include/c++/12.3.1/aarch64-none-elf/bits/cpu_defines.h /home/$DEV_USERNAME/dev/gcc-cross/aarch64-none-elf/aarch64-none-elf/include/bits/.
    sudo -u $DEV_USERNAME cp /home/$DEV_USERNAME/dev_tools/$ARM_TOOLCHAIN_NAME/aarch64-none-elf/include/c++/12.3.1/aarch64-none-elf/bits/os_defines.h /home/$DEV_USERNAME/dev/gcc-cross/aarch64-none-elf/aarch64-none-elf/include/bits/.

    #   Install Catch2 for Unit Testing

    sudo -u $DEV_USERNAME mkdir /home/$DEV_USERNAME/dev_tools/Catch2
    sudo -u $DEV_USERNAME mkdir /home/$DEV_USERNAME/dev_tools/Catch2_build

    cd /home/$DEV_USERNAME/dev_tools/Catch2_build
    sudo -u $DEV_USERNAME git clone https://github.com/catchorg/Catch2.git

    cd /home/$DEV_USERNAME/dev_tools/Catch2_build/Catch2
    sudo -u $DEV_USERNAME cmake -Bbuild -H. -DBUILD_TESTING=OFF -DCMAKE_INSTALL_PREFIX=/home/$DEV_USERNAME/dev_tools/Catch2
    sudo -u $DEV_USERNAME cmake --build build/ --target install

fi