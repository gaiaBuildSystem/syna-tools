# Bash script: subimage: bootloader: spi

# Generate subimg
if [ "is${CONFIG_UBOOT_SUBOOT}" = "isy" ]; then
  ${basedir_tools}/prepend_image_info.sh ${outdir_uboot_oemboot_release}/uboot_en.bin ${outfile_bootloader_subimg}
fi
