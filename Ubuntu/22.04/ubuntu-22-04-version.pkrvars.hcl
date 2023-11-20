
template_name = "ubuntu-22-04-3-{{ isotime \"2006-01-02-T15-04-05\" }}"
template_description = "Ubuntu 22.04.3 created on {{ isotime \"2006-01-02T15:04:05\" }}"
ubuntu_build_name = "jammy"
iso_name = "ubuntu-22.04.3-live-server-amd64.iso"
iso_path = "iso"
iso_url = "https://releases.ubuntu.com/jammy/ubuntu-22.04.3-live-server-amd64.iso"
iso_checksum = "a4acfda10b18da50e2ec50ccaf860d7f20b389df8765611142305c0e911d16fd"
iso_checksum_type = "sha256"
boot_command = ["c",
                "linux /casper/vmlinuz --- autoinstall ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/' ",
                "<enter><wait>",
                "<enter><wait>",
                "initrd /casper/initrd<enter><wait>",
                "<enter><wait>",
                "boot",
                "<enter>"]
http_directory = "./22.04/http"
