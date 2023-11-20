This directory contains the proxmox specific files for building an Ubuntu VM on a Proxmox server.

The example command line below should be executed from the main directory, i.e. not from this one.  


packer build -var "dev_username=?????" -var "dev_password=?????" -var "proxmox_host=????" -var "proxmox_node_name=????" -var "proxmox_api_user=packer@pve" -var "proxmox_api_password=ubuntu" -var "ssh_username=packer" -var "ssh_password=ubuntu" -var "vmid=4080" -var "http_interface=Wi-Fi" -var-file="./20.04/ubuntu-20-04-version.pkrvars.hcl" -var-file="./proxmox/proxmox-config.pkrvars.hcl" -var-file="vm_personalization.pkrvars.hcl" ./proxmox/ubuntu-proxmox.pkr.hcl