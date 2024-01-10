# Packer Specifications
 
 
This projects contains two sub-projects which use Packer to build and customize Ubuntu VMs or Raspberry Pi images.  The Raspberry Pi image subproject is optionally used by the Ubuntu subproject.

## General Design

The general design approach is to use Packer to build a 'vanilla' VM on either a Proxmox or VirtualBox hypervisor and then provide a collection of scripts and command line settings which can be used to customize the VMs post-creation.  For example, one script creates a 'development user' with a one-time-use password and another script sets up the basic build tools in the VM for C/C++ or Python3 development.

For the RPI image build, there is a script which installs QEMU into the image and a set of tools which in turn permits the creation of RPI images in the QEMU ARM Virtual Machine and then customize that image - for example configuring WiFi.  This capability is derived from Mateusz Kaczanowski's PackerBuilderArm Project (https://github.com/mkaczanowski/packer-builder-arm).

Each subproject has its own README files with additional documentation and examples.
