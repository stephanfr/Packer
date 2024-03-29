# Ubuntu Packer Specifications
 
 
Packer scripts for generating Proxmox templates or VirtualBox VMs for Ubuntu 20.04 and 22.04 Live Server.

These scripts are in HCL2 and require initializing Packer.  Typically, I just grab the latest
version of Packer and drop it into this directory.  Initialization for each hypervisor
is straightforward:

*Packer init -upgrade ./proxmox*
*Packer init -upgrade ./virtualbox*

The initialization will insure the the required Packer plugins are loaded and up to date.

## Common Settings

Two Packer builders are supported: Proxmox and VirtualBox.  In general, the only substantive difference between building in Proxmox or Virtualbox is that the Proxmox builder has a handful more settings which must be set.  VirtualBox is supported only for local builds, i.e. on the machine running Packer.  The VMs produced in either environment will be functionally identical if the same command line settings are used.

A short Packer Variables file: 'vm_personalization.pkrvars.hcl' can be used to save common settings.  By default it only includes four variables:

    "vm_name" - name for the template
    "install_vscode_ide" - boolean to determine if VSCode IDE should be installed in the VM.  Defaults to 'false'
    "install_dev_tools_base" - installs basic C/C++ and Python3 development tools and libraries.  Defaults to 'true'
    "install_minikube" - installs Minikube in the target VM.  Defaults to 'false'
    "install_aarch64_cross" - installs ARM Aarch64 cross-compiling tools.  Defaults to 'false'
    "install_rpi_packer_tools" - installs tooling to build RPi images in the target VM.  Defaults to 'false'
    "dev_username" - development username
    "dev_password" - initial password, will be prompted to change on login

If the dev username is not specified, then the dev user is not created.  These values can be set on the Packer command line as shown below.  The VM will force changing the development password on first login, so a common password can be used in the file or command line.

The script assumes that there will be a directory named 'uploads' in the same
directory holding the Packer json file and in the uploads directory.  Optionally,
if a file named 'rsa.pub' which holds the public key for the development
user who will be connecting to the VM is present in that directory, it will be
added as an ssh key for the user.

The image specific values for a specific Ubuntu version can be found in pkrvars.hcl files
with names 'ubuntu-xx-xx-x-version.pkrvars.hcl' which are located in subdirectories with names matching the major release numbers.  Currently both Ubuntu 20.04 and 22.04 are supported.


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

Values to change in 'proxmox-config.pkrvars.hcl' :

    "proxmox_host" - set to the IP Address or URL of your Proxmox host
    "proxmox_node_name" - name of the node on which to create the template
    "proxmox_api_user" - username for the proxmox user with privs to create VMs
    "proxmox_api_password" - password for user api user
    "vmid" - set to the numeric identifier for the template
    
The rest of the values should be pretty self-explanatory.  The main ones which
one might want to change are the version #s for ubuntu.  Beware the *proxmox_node_name*, this name must match the name of the node EXACTLY and must be resolvable by DNS.  If both requirements are not met, you will get misleading error messages.

To build a template, the command line should look something like the following (make the correct subsitutions for your environment) :

~~~
packer build -var "dev_username=????" -var "dev_password=password" -var "proxmox_host=????" -var "proxmox_node_name=????" -var "proxmox_api_user=packer@pve" -var "proxmox_api_password=password" -var "ssh_username=packer" -var "ssh_password=ubuntu" -var "vmid=????" -var "http_interface=Wi-Fi" -var-file="./22.04/ubuntu-22-04-version.pkrvars.hcl" -var-file="./proxmox/proxmox-config.pkrvars.hcl" -var-file="vm_personalization.pkrvars.hcl" ./proxmox/ubuntu-proxmox.pkr.hcl
~~~

The template build process may take a while as the OS install also updates packages.

If the install seems to stall and the ssh shell is never available, it might be necessary to set the variable *http_interface* (as shown above) to the interface of on which the http service for the autoinstaller should be exposed.  Packer is not super-smart about choosing interfaces, so it is possible the http server could end up on a VPN interface or some other private interface.


## VirtualBox Builder

VirtualBox specific files can be found in the *virtualbox* subdirectory.

The VirtualBox builder does not require any of the extra config settings required by Proxmox, but does assume that VirtualBox is installed locally.  The script must find the VBoxManage application, so it is tpyically required to add the path to the
application to the command shell path.  The example below is for Windows:

*PATH=%PATH%;C:\Program Files\Oracle\VirtualBox*

To build a VM, the command line should look something like the following (make the correct subsitutions for your environment) :

~~~
packer build -var "dev_username=????" -var "dev_password=password" -var "ssh_username=packer" -var "ssh_password=ubuntu" -var -var-file="./22.04/ubuntu-22-04-version.pkrvars.hcl" -var-file="./virtualbox/virtualbox-config.pkrvars.hcl" -var-file="vm_personalization.pkrvars.hcl" ./virtualbox/ubuntu-virtualbox.pkr.hcl
~~~


## RPI Packer Tools

Both builders can also produce VM images prepared to build RPi images using QEMU.  The advantage of this approach is that all the build and configure activity occurs on an X86-64 server and the final product is a bootable, fully prepared RPi image with pre-configured WiFi and build tools that simply needs to be placed on a SD card.

Add the following variable to the command line for the Proxmox builder above and run it.  The go to the RPi directory of this repository for instructions on how to run the builder in the VM.

~~~
-var "install_rpi_packer_tools=true"
~~~



