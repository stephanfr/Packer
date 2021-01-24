# PackerScripts
 
 
Packer scripts for generating Proxmox templates for Ubuntu 20.04 Live Server.


This packer spec will create a new VM template on Proxmox, generated from
the specified version of Ubuntu Server and will then install Mate Desktop
and a base set of developer tools.  Optionally, the Visual Studio Code IDE
can be installed, but this is not needed for deployments in which the VM
generated from the template will be use for remote development using the VSC
SSH remote development extension.


Below are values currently empty in the variable files which will need to
be assigned for the spec and scripts to work properly.


Values to change in 'config.json' :

    "proxmox_host" - set to the IP Address or URL of your Proxmox host
    "proxmox_node_name" - name of the node on which to create the template
    "vmid" - set to the numeric identifier for the template
    
The rest of the values should be pretty self-explanatory.  The main ones which
one might want to change are the version #s for ubuntu.

    
    
Values to change in 'vm_personalization.json' :

    "vm_name" - name for the template
    "install_vscode_ide" - true/false to install the VSCode IDE
    "dev_username" - development username
    "dev_password" - initial password, will be prompted to change on login
    

The script assumes that there will be a directory named 'uploads' in the same
directory holding the packer json file and in the uploads directory, there will
be a file named 'rsa.pub' which holds the public key for the development
user who will be connecting to the VM.


To build the template, use the following command line:

./packer build -var-file=config.json -var-file=vm_personalization.json ubuntu-20.04.json



