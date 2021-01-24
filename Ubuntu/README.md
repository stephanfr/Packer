# Ubuntu Packer Specifications
 
 
Packer scripts for generating Proxmox templates for Ubuntu 20.04 Live Server.


This packer spec will create a new VM template on Proxmox, generated from
the specified version of Ubuntu Server and will then install Mate Desktop
and a base set of developer tools.  Optionally, the Visual Studio Code IDE
can be installed, but this is not needed for deployments in which the VM
generated from the template will be use for remote development using the VSC
SSH remote development extension.

Two packer specifications are currently available:

ubuntu-proxmox.json - creates a basic Ubuntu image for development
ubuntu-rpi-packer-proxmox.json - creates a VM which is configured to then create
raspberry pi images with customizations using a builder that executes the image 
using qemu in the x86 VM

The Raspberry Pi building specification uses the packer-arm-builder from https://github.com/mkaczanowski/packer-builder-arm  This is a fantastic tool for customizing rspberry pi images prior to flshing to a microSD card for booting the Pi.

Below are values currently empty in the variable files which will need to
be assigned for the spec and scripts to work properly.


Values to change in 'config.json' :

    "proxmox_host" - set to the IP Address or URL of your Proxmox host
    "proxmox_node_name" - name of the node on which to create the template
    "proxmox_api_user" - username for the proxmox user with privs to create VMs
    "proxmox_api_password" - password for user api user
    "vmid" - set to the numeric identifier for the template
    
The rest of the values should be pretty self-explanatory.  The main ones which
one might want to change are the version #s for ubuntu.

Values to change in 'vm_personalization.json' :

    "vm_name" - name for the template
    "install_vscode_ide" - true/false to install the VSCode IDE
    "dev_username" - development username
    "dev_password" - initial password, will be prompted to change on login

If the dev username is not specified, then the dev user is not created.

The script assumes that there will be a directory named 'uploads' in the same
directory holding the packer json file and in the uploads directory.  Optionally,
if a file named 'rsa.pub' which holds the public key for the development
user who will be connecting to the VM is present in that directory, it will be
added as an ssh key for the user.

The image specific values for a specific Ubuntu version can be found in json files
with names 'ubuntu-xx-xx-x-version.json'.

The Packer .exe is a single file, I just drop it into the /Packer/Ubuntu directory
and use the app for there.  These scripts were built with Packer v1.6.6.


To build a template, use following command line should look something like (make the correct subsitutions for your environment) :

./packer build -var 'dev_username=dev' -var 'dev_password=password' -var 'proxmox_host=proxmox.example.net' -var 'proxmox_node_name=ProxmoxNode' -var 'proxmox_api_user=packer@pve' -var 'proxmox_api_password=packer' -var 'vmid=4020' -var-file ubuntu-20-04-1-version.json -var-file config.json -var-file vm_personalization.json ubuntu-proxmox.json 




