
variable "boot_command" {
  type = list(string)
}

variable "boot_command_prefix" {
  type = list(string)
  default = ["<esc><wait><esc><wait><f6><wait><esc><wait>"]
}

variable "cores" {
  type = string
}

variable "dev_password" {
  type = string
}

variable "dev_username" {
  type = string
}

variable "disable_ipv6" {
  type = string
}

variable "disk_size" {
  type = string
}

variable "http_directory" {
  type = string
}

variable "http_bind_address" {
  type = string
  default = "127.0.0.1"
}

variable "http_proxy" {
  type = string
  default = env("http_proxy")
}

variable "https_proxy" {
  type = string
  default = env("https_proxy")
}

variable "iso_checksum" {
  type = string
}

variable "iso_checksum_type" {
  type = string
}

variable "iso_url" {
  type = string
}

variable "memory" {
  type = string
}

variable "no_proxy" {
  type = string
  default = env("no_proxy")
}

variable "ssh_password" {
  type = string
}

variable "ssh_username" {
  type = string
}

variable "template_name" {
  type = string
}

variable "ubuntu_build_name" {
  type = string
}

variable "update" {
  type = string
}

variable "vram" {
  type = string
}


#
#  Script selection variables
#

variable "install_dev_tools_base" {
  type = string
  default = "true"
}

variable "install_minikube" {
  type = string
  default = "false"
}

variable "install_vscode_ide" {
  type = string
  default = "false"
}

variable "install_aarch64_cross" {
  type = string
  default = "false"
}

variable "install_rpi_packer_tools" {
  type = string
  default = "false"
}


#
#  Load required plugins
#

packer {
  required_plugins {
    name = {
      version = "~> 1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}


#
#  Builder
#


source "virtualbox-iso" "ubuntu" {
  iso_checksum   = "${var.iso_checksum_type}:${var.iso_checksum}"
  iso_url        = "${var.iso_url}"

  boot_command   = concat( "${var.boot_command_prefix}", "${var.boot_command}" )
  boot_wait      = "5s"
  
  guest_os_type  = "Ubuntu_64"
  cpus           = "${var.cores}"
  disk_size      = "${var.disk_size}"
  format         = "ova"
  gfx_controller = "vmsvga"
  gfx_vram_size  = "${var.vram}"
  memory         = "${var.memory}"
  nic_type       = "virtio"

  http_bind_address = "${var.http_bind_address}"
  http_directory = "${var.http_directory}"

  ssh_username   = "${var.ssh_username}"
  ssh_password   = "${var.ssh_password}"
  ssh_timeout    = "120m"
  
  vboxmanage     = [["modifyvm", "{{ .Name }}", "--hwvirtex", "on"],
                    ["modifyvm", "{{ .Name }}", "--nestedpaging", "on"],
                    ["modifyvm", "{{ .Name }}", "--nat-localhostreachable1", "on"]]
  vm_name        = "${var.template_name}"
  shutdown_command = "echo '${var.ssh_password}' | sudo -S shutdown -P now"
}


build {
  sources = ["source.virtualbox-iso.ubuntu"]

  provisioner "shell" {
    inline = ["while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done"]
  }

  provisioner "file" {
    destination = "/tmp"
    source      = "uploads"
  }

  provisioner "shell" {
    inline = ["chmod -R 777 /tmp/uploads"]
  }

  provisioner "shell" {
    environment_vars = ["VIRTUALBOX=true",
                        "DEBIAN_FRONTEND=noninteractive",
                        "UPDATE=${var.update}",
                        "DISABLE_IPV6=${var.disable_ipv6}",
                        "SSH_USERNAME=${var.ssh_username}",
                        "SSH_PASSWORD=${var.ssh_password}",
                        "http_proxy=${var.http_proxy}",
                        "https_proxy=${var.https_proxy}",
                        "no_proxy=${var.no_proxy}",
                        "DEV_USERNAME=${var.dev_username}",
                        "DEV_PASSWORD=${var.dev_password}",
                        "INSTALL_DEV_TOOLS_BASE=${var.install_dev_tools_base}",
                        "INSTALL_MINIKUBE=${var.install_minikube}",
                        "INSTALL_VSCODE_IDE=${var.install_vscode_ide}",
                        "INSTALL_AARCH64_CROSS=${var.install_aarch64_cross}",
                        "INSTALL_RPI_PACKER_TOOLS=${var.install_rpi_packer_tools}",
                        "UBUNTU_BUILD_NAME=${var.ubuntu_build_name}"]

    execute_command  = "echo '${var.ssh_password}'|{{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    
    scripts          = ["script/mate_desktop.sh",
                        "script/dev_tools_base.sh",
                        "script/setup_dev_user.sh",
                        "script/install_vscode.sh",
                        "script/install_aarch64_cross.sh",
                        "script/install_rpi_packer_tools.sh",
                        "script/cleanup.sh"]
  }

}
