
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

variable "datastore" {
  type = string
}

variable "datastore_type" {
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

variable "http_interface" {
  type = string
  default = "0.0.0.0"
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

variable "iso_name" {
  type = string
}

variable "iso_path" {
  type = string
}

variable "iso_storage_pool" {
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

variable "proxmox_api_password" {
  type = string
}

variable "proxmox_api_port" {
  type = string
}

variable "proxmox_api_user" {
  type = string
}

variable "proxmox_host" {
  type = string
}

variable "proxmox_node_name" {
  type = string
}

variable "sockets" {
  type = string
}

variable "ssh_password" {
  type = string
}

variable "ssh_username" {
  type = string
}

variable "template_description" {
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

variable "vmid" {
  type = string
}

//
//  Script selection variables
//

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
      source  = "github.com/hashicorp/proxmox"
    }
  }
}


#
#  Builder
#

source "proxmox-iso" "ubuntu" {
  iso_checksum         = "${var.iso_checksum_type}:${var.iso_checksum}"
  iso_storage_pool     = "${var.iso_storage_pool}"
  iso_urls             = ["${var.iso_path}/${var.iso_name}", "${var.iso_url}"]
  unmount_iso          = true
  
  insecure_skip_tls_verify = true

  boot_command         = concat( "${var.boot_command_prefix}", "${var.boot_command}" )
  boot_wait            = "5s"                                                               # This is a potentially delicate setting.  To get into GRUB, the builder has to send an ESC after the BIOS but before boot

  sockets              = "${var.sockets}"
  cores                = "${var.cores}"
  cpu_type             = "host"
  memory               = "${var.memory}"

  disks {
    cache_mode         = "writeback"
    disk_size          = "${var.disk_size}"
    format             = "raw"
    storage_pool       = "${var.datastore}"
    type               = "scsi"
  }

  network_adapters {
    bridge             = "vmbr0"
    model              = "virtio"
  }

  vga {
    memory             = 32
    type               = "qxl"
  }

  http_interface       = "${var.http_interface}"
  http_directory       = "${var.http_directory}"

  node                 = "${var.proxmox_node_name}"
  os                   = "l26"
  proxmox_url          = "https://${var.proxmox_host}:${var.proxmox_api_port}/api2/json"

  vm_id                = "${var.vmid}"
  vm_name              = "${var.template_name}"
  template_description = "${var.template_description}"

  qemu_agent           = true

  username             = "${var.proxmox_api_user}"
  password             = "${var.proxmox_api_password}"

  ssh_username         = "${var.ssh_username}"
  ssh_password         = "${var.ssh_password}"
  ssh_timeout          = "45m"
}

build {
  sources = ["source.proxmox-iso.ubuntu"]

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

    environment_vars = ["DEBIAN_FRONTEND=noninteractive",
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
                        "UBUNTU_BUILD_NAME=${var.ubuntu_build_name}" ]

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
