
image_file_url = "https://downloads.raspberrypi.com/raspios_arm64/images/raspios_arm64-2023-10-10/2023-10-10-raspios-bookworm-arm64.img.xz"
file_target_extension = "xz"
file_unarchive_cmd    = ["xz", "--decompress", "$ARCHIVE_PATH"]
output_image_path = "raspios-bookworm-arm64.img"
