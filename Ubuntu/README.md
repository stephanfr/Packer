# Ubuntu Packer Specifications
 
 
Packer scripts for generating Proxmox templates or VirtualBox VMs for Ubuntu 20.04 and 22.04 Live Server.

These scripts are in HCL2 and require initializing Packer.  Typically, I just grab the latest
version of Packer and drop it into this directory.  Initialization for each hypervisor
is straightforward:

*Packer init -upgrade ./proxmox*
*Packer init -upgrade ./virtualbox*

The initialization will insure the the required Packer plugins are loaded and up to date.


## Proxmox Builder

Proxmox specific files can be found in the *proxmox* subdirectory.

This Packer spec will create a new VM template on Proxmox, generated from
the specified version of Ubuntu Server and will then install Mate Desktop
and a base set of developer tools.  There are a number of optional elements that can be
added to the VM.  These are listed in a section that follows.

The Packer plugin is automatically loaded by the specification.

Below are values currently empty in the variable files which will need to
be assigned for the spec and scripts to work properly.  Alternatively, these values
can be set on the command line as shown on the example at the end of this section.

Values to change in 'proxmox-config.json' :

    "proxmox_host" - set to the IP Address or URL of your Proxmox host
    "proxmox_node_name" - name of the node on which to create the template
    "proxmox_api_user" - username for the proxmox user with privs to create VMs
    "proxmox_api_password" - password for user api user
    "vmid" - set to the numeric identifier for the template
    
The rest of the values should be pretty self-explanatory.  The main ones which
one might want to change are the version #s for ubuntu.  Beware the *proxmox_node_name*, this name must match the name of the node EXACTLY and must be resolvable by DNS.  If both requirements are not met, you will get misleading error messages.

Values to change in 'vm_personalization.json' :

    "vm_name" - name for the template
    "dev_username" - development username
    "dev_password" - initial password, will be prompted to change on login

If the dev username is not specified, then the dev user is not created.  Again, these values can be set on the Packer command line as shown below.  The VM will force changing the development password on first login, so a common password can be used in the file or command line.

The script assumes that there will be a directory named 'uploads' in the same
directory holding the Packer json file and in the uploads directory.  Optionally,
if a file named 'rsa.pub' which holds the public key for the development
user who will be connecting to the VM is present in that directory, it will be
added as an ssh key for the user.

The image specific values for a specific Ubuntu version can be found in json files
with names 'ubuntu-xx-xx-x-version.json' which are located in subdirectories with names matching the major release numbers.  Currently both Ubuntu 20.04 and 22.04 are supported.

To build a template, use following command line should look something like (make the correct subsitutions for your environment) :

~~~
Packer build -var "dev_username=????" -var "dev_password=password" -var "proxmox_host=????" -var "proxmox_node_name=????" -var "proxmox_api_user=Packer@pve" -var "proxmox_api_password=ubuntu" -var "ssh_username=Packer" -var "ssh_password=ubuntu" -var "vmid=????" -var "http_interface=Wi-Fi" -var-file="./20.04/ubuntu-20-04-version.pkrvars.hcl" -var-file="./proxmox/proxmox-config.pkrvars.hcl" -var-file="vm_personalization.pkrvars.hcl" ./proxmox/ubuntu-proxmox.pkr.hcl
~~~

The template build process may take a while as the OS install also updates packages.

If the install seems to stall and the ssh shell is never available, it might be necessary to set the variable *http_interface* to the interface of on which the http service for the autoinstaller should be exposed.  Packer is not super-smart about choosing interfaces, so it is possible the http server could end up on a VPN interface or some other private interface.


## Proxmox RPI Builder

Proxmox specific files can be found in the *proxmox* subdirectory.

This Packer spec will create a new VM template on Proxmox, generated from
the specified version of Ubuntu Server and will then install Mate Desktop
and a base set of developer tools.  There are a number of optional elements that can be
added to the VM.  These are listed in a section that follows.

Two Packer specifications are currently available:

ubuntu-proxmox.json - creates a basic Ubuntu image for development

ubuntu-rpi-Packer-proxmox.json - creates a VM which is configured to then create
raspberry pi images with customizations using a builder that executes the image 
using qemu in the x86 VM.

The Packer plugin is automatically loaded by the specification.

The Raspberry Pi building specification uses the Packer-arm-builder from https://github.com/mkaczanowski/Packer-builder-arm  This is a fantastic tool for customizing rspberry pi images prior to flshing to a microSD card for booting the Pi.

Below are values currently empty in the variable files which will need to
be assigned for the spec and scripts to work properly.


Values to change in 'proxmox-config.json' :

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
directory holding the Packer json file and in the uploads directory.  Optionally,
if a file named 'rsa.pub' which holds the public key for the development
user who will be connecting to the VM is present in that directory, it will be
added as an ssh key for the user.

The image specific values for a specific Ubuntu version can be found in json files
with names 'ubuntu-xx-xx-x-version.json'.

The Packer .exe is a single file, I just drop it into the /Packer/Ubuntu directory
and use the app for there.  These scripts were built with Packer v1.6.6.


To build a template, use following command line should look something like (make the correct subsitutions for your environment) :

Packer build -var "dev_username=?????" -var "dev_password=?????" -var "proxmox_host=????" -var "proxmox_node_name=????" -var "proxmox_api_user=Packer@pve" -var "proxmox_api_password=ubuntu" -var "ssh_username=Packer" -var "ssh_password=ubuntu" -var "vmid=4080" -var "http_interface=Wi-Fi" -var-file="./20.04/ubuntu-20-04-version.pkrvars.hcl" -var-file="./proxmox/proxmox-config.pkrvars.hcl" -var-file="vm_personalization.pkrvars.hcl" ./proxmox/ubuntu-proxmox.pkr.hcl




