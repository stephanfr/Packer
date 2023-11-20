
template_name = "ubuntu-20-04-4-{{ isotime \"2006-01-02-T15-04-05\" }}"
template_description = "Ubuntu 20.04.4 created on {{ isotime \"2006-01-02T15:04:05\" }}"
ubuntu_build_name = "focal"
iso_name = "ubuntu-20.04.4-live-server-amd64.iso"
iso_path = "iso"
iso_url = "http://old-releases.ubuntu.com/releases/20.04.4/ubuntu-20.04.4-live-server-amd64.iso"
iso_checksum = "28ccdb56450e643bad03bb7bcf7507ce3d8d90e8bf09e38f6bd9ac298a98eaad"
iso_checksum_type = "sha256"
boot_command = ["<bs><bs><bs><bs><bs>",
                "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ",
                "--- <enter>"]
http_directory = "./20.04/http"
