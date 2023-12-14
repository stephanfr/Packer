
image_file_url = "https://downloads.raspberrypi.com/raspios_lite_armhf/images/raspios_lite_armhf-2023-12-11/2023-12-11-raspios-bookworm-armhf-lite.img.xz"
file_target_extension = "xz"
file_unarchive_cmd    = ["xz", "--decompress", "$ARCHIVE_PATH"]
output_image_path = "raspios-lite-bookworm-armhf.img"
