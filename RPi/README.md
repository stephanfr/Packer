# Raspberry Pi Packer Specifications
 
The intent of this project is to enable users to build a complete, customized Raspberry Pi image in an X86 VM.  This specification will pre-configure the pi image with wifi connectivity and includes support for remote C/C++ development from VSCode and library support for C/C++ apps using the PIGPIO library.  This specification relies on Mateusz Kaczanowski's PackerBuilderArm Project (https://github.com/mkaczanowski/packer-builder-arm) which extends Packer to support user mode QEMU ARM emulation to launch the ARM image on an X86 VM and then customize that image.  This elegant solution permits the creation of complete, ready-to-boot Raspbery Pi images with additional libraries and tooling pre-installed.

This specification will create a non-root 'Dev User' with a default password.  The development user must login to the image once to change the password from the default specified in the script command line.  This behavior can be modified and the forced password expiration eliminated.  Additionally, this specification provides the ability to upload a public RSA key which can be used for SSH authentication without passwords.  The RSA key is configured for the development user.

This repository should be merged to the 'packer-builder-arm' directory created in a VM generated using the ubuntu-rpi-packer-proxmox.json specification found in the Packer/Ubuntu repository.  The packer executable itself should be placed in this directory as well.

This specification builds and installs CMake in the image to support CMake tooling in VS Code.  Additionally, it will build and install the PIGPIO library UNLESS the 'pigpio_url' variable is set empty.

Of note, the following two compiler flags must be set to work around a user mode QEMU ARM issue :

export CFLAGS="-D_FILE_OFFSET_BITS=64"
export CXXFLAGS="-D_FILE_OFFSET_BITS=64"

Without these flags set, the libraries and executables built in QEMU ARM User Mode will fail in generally enigmatic ways.  I believe the problem is a mismatch between the file offset sizes returned from the linux host in QEMU ARM User Mode and the file offset sizes returned by a genuine ARM kernel.  My understanding of QEMU User Space emulation is less than complete, but I believe that amongst other things, it performs SYSCALL translation between the ARM Executable and the host kernel.  Somehere along the way, the file offset size appears to be improperly handled.  Hopefully, this gets addressed in the user mode emulator but for now - the compiler flags are required.  All this said, once those flags are set, everything appears to execute correctly - which is really pretty specactular when you stop to think about it.

Below are values currently empty in the variable files which will need to be assigned for the spec and scripts to work properly.

Values to provide :

    "wifi_ssid" - if provided, the SSID of the wifi network
    "wifi_password" - if provided, the password for the wifi network, if not provided the network is treated as open
    "dev_username" - if provided, development username; password must be changed on first login
    "dev_password" - initial password
    "new_pi_password" - if provided, new password for pi user
    "ssh_key_filename" - filename for public key to be copied from the upload folder; defaults to "id_rsa.pub"
    "nfs_copy_location" - an NFS mount to which the completed image will be copied
    "cmake_url" - URL for the version of CMake to download, defaults to URL for CMake 3.19.4
    "cmake_version" - version id of CMake to build, defaults to CMake version 3.19.4
    "pigpio_url" - URL for PIGPIO library, defaults to current master - pass empty URL to not build library

The script assumes that there will be a directory named 'uploads' in the same directory holding the packer json file and in the uploads directory.  Optionally,
if a file named 'rsa.pub' which holds the public key for the development user who will be connecting to the VM is present in that directory, it will be
added as an ssh key for the user.  The 'uploads' directory must be created or the script will fail.

There is a post processor which will copy the image off the VM to a NFS location such that it can be picked up and flashed to an SD.  If you do not wish to copy the image, just remove the post-processor.

The image specific values for a specific raspios version can be found in json files with names 'raspios_label-xx-xx-x-version.json'.

The Packer .exe is a single file, I just drop it into the /Packer/RPi directory and use the app for there.  These scripts were built with Packer v1.6.6.

To build a template, use following command line should look something like (make the correct subsitutions for your environment) :

sudo packer build -var 'wifi_ssid=???????' -var 'wifi_password=??????' -var 'dev_username=dev' -var 'dev_password=password' -var 'new_pi_password=newpwd' -var-file raspios_lite_armhf-2021-01-12-version.json armhf.json

Since this script uses the QEMU builder, it must be run with elevated privileges.

