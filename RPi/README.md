# Raspberry Pi Packer Specifications
 
 
Packer specification and scripts for generating customized Raspberry Pi Images.  This repository should be added to the 'packer-builder-arm' directory created in a VM generated using the ubuntu-rpi-packer-proxmox.json specification found in the Packer/Ubuntu repository.  The packer executable itself should be placed in this directpory as well.

Below are values currently empty in the variable files which will need to
be assigned for the spec and scripts to work properly.

Values to provide :

    "wifi_name" - if provided, the SSID of the wifi network
    "wifi_password" - if provided, the password for the wifi network, if not provided the network is treated as open
    "dev_username" - if provided, development username
    "dev_password" - initial password, will be prompted to change on login
    "new_pi_password" - if provided, new password for pi user

The script assumes that there will be a directory named 'uploads' in the same
directory holding the packer json file and in the uploads directory.  Optionally,
if a file named 'rsa.pub' which holds the public key for the development
user who will be connecting to the VM is present in that directory, it will be
added as an ssh key for the user.  The 'uploads' directory must be created or the script will fail.

The image specific values for a specific raspios version can be found in json files
with names 'raspios_label-xx-xx-x-version.json'.

The Packer .exe is a single file, I just drop it into the /Packer/RPi directory
and use the app for there.  These scripts were built with Packer v1.6.6.

To build a template, use following command line should look something like (make the correct subsitutions for your environment) :

sudo packer build -var 'wifi_name=ssid' -var 'wifi_password=??????' -var 'dev_username=dev' -var 'dev_password=password' -var 'new_pi_password=newpwd' -var-file raspios_lite_armhf-2021-01-12-version.json raspios-lite-armhf.json

Since this script uses a qemu builder, it must be run with elevated privileges.

