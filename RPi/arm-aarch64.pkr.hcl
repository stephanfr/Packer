
variable "cmake_version" {
  type    = string
  default = "cmake-3.27.8"
}

variable "catch2_url" {
  type    = string
  default = "https://github.com/catchorg/Catch2.git"
}

variable "cmake_url" {
  type    = string
  default = "https://cmake.org/files/v3.27/cmake-3.27.8.tar.gz"
}

variable "googletest_url" {
  type    = string
  default = "https://github.com/google/googletest.git -b v1.14.x"
}

variable "pigpio_url" {
  type    = string
  default = "https://github.com/joan2937/pigpio/archive/master.zip"
}



variable "cpu_arch" {
  type    = string
  default = "AARCH64"
}

variable "dev_password" {
  type    = string
  default = ""
}

variable "dev_username" {
  type    = string
  default = ""
}

variable "image_file_url" {
  type    = string
  default = ""
}

variable "new_pi_password" {
  type    = string
  default = ""
}

variable "nfs_copy_location" {
  type    = string
  default = "nas:/mnt/Primary/share/RPiImages"
}

variable "output_image_path" {
  type = string
}

variable "ssh_key_filename" {
  type    = string
  default = "id_rsa.pub"
}

variable "ssh_password" {
  type    = string
  default = "raspberry"
}

variable "ssh_username" {
  type    = string
  default = "pi"
}

variable "wifi_password" {
  type    = string
  default = ""
}

variable "wifi_ssid" {
  type    = string
  default = ""
}


source "arm" "QEMUBuilder" {
  file_checksum_type    = "sha256"
  file_checksum_url     = "${var.image_file_url}.sha256"
  file_target_extension = "xz"
  file_unarchive_cmd    = ["xz", "--decompress", "$ARCHIVE_PATH"]
  file_urls             = ["${var.image_file_url}"]
  image_build_method    = "resize"
  image_chroot_env      = ["PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"]
  image_path            = "${var.output_image_path}"
  image_size            = "8G"
  image_type            = "dos"
  image_partitions {
    filesystem   = "vfat"
    mountpoint   = "/boot"
    name         = "boot"
    size         = "256M"
    start_sector = "8192"
    type         = "c"
  }
  image_partitions {
    filesystem   = "ext4"
    mountpoint   = "/"
    name         = "root"
    size         = "0"
    start_sector = "532480"
    type         = "83"
  }
  qemu_binary_destination_path = "/usr/bin/qemu-aarch64-static"
  qemu_binary_source_path      = "/usr/bin/qemu-aarch64-static"
}


build {
  sources = ["source.arm.QEMUBuilder"]

  provisioner "file" {
    destination = "/tmp"
    source      = "uploads"
  }

  provisioner "shell" {
    inline = ["chmod -R 777 /tmp/uploads"]
  }

  provisioner "shell" {
    inline = ["touch /boot/ssh"]
  }

  provisioner "shell" {
    environment_vars = ["CPU_ARCH=${var.cpu_arch}",
                        "WIFI_SSID=${var.wifi_ssid}",
                        "WIFI_PASSWORD=${var.wifi_password}",
                        "NEW_PI_PASSWORD=${var.new_pi_password}",
                        "DEV_USERNAME=${var.dev_username}",
                        "DEV_PASSWORD=${var.dev_password}",
                        "SSH_KEY_FILENAME=${var.ssh_key_filename}",
                        "CMAKE_URL=${var.cmake_url}",
                        "CMAKE_VERSION=${var.cmake_version}",
                        "PIGPIO_URL=${var.pigpio_url}",
                        "GOOGLETEST_URL=${var.googletest_url}",
                        "CATCH2_URL=${var.catch2_url}"]

    execute_command  = "echo '${var.ssh_password}'|{{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    
    scripts          = ["scripts/setup-wifi.sh",
                        "scripts/setup-dev-user.sh",
                        "scripts/dev-tools-base.sh",
                        "scripts/change-pi-password.sh"]
  }

  post-processor "shell-local" {
    inline_shebang = "/bin/bash -eu"
    inline = ["if [[ -d /tmp/nfsloc ]]; then umount -f /tmp/nfsloc; rm -rf /tmp/nfsloc; fi", "mkdir /tmp/nfsloc", "mount -t nfs ${var.nfs_copy_location} /tmp/nfsloc", "cp ${var.output_image_path} /tmp/nfsloc/", "umount /tmp/nfsloc", "rm -rf /tmp/nfsloc"]
  }
}