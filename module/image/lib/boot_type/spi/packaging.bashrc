# Bash script: boot_type: SPI

genx_spi_suboot_combo() {
  # Parse arguments
  local f_preboot
  local f_tee
  local f_bl
  local f_spi_combo


  f_preboot=$1; shift
  f_tee=$1; shift
  f_bl=$1; shift
  f_spi_combo=$1; shift

  # Pack preboot
  dd if=/dev/zero bs=1024 count=1 > $f_spi_combo
  cat $f_preboot >> $f_spi_combo

  preboot_size=`stat -c %s ${f_spi_combo}`
  padding_size=$[524288 - $preboot_size]

  f_PADDING=${outdir_product_release_spi}/dummy.bin
  dd if=/dev/zero of=$f_PADDING bs=1 count=$padding_size
  cat $f_PADDING >> $f_spi_combo

  # Pack TEE
  cat $f_tee >> $f_spi_combo

  tee_size=`stat -c %s ${f_spi_combo}`
  padding_size=$[1114112 - $tee_size]

  f_PADDING=${outdir_product_release_spi}/dummy.bin
  dd if=/dev/zero of=$f_PADDING bs=1 count=$padding_size
  cat $f_PADDING >> $f_spi_combo

  # Pack BL
  cat $f_bl >> $f_spi_combo

  bl_size=`stat -c %s ${f_spi_combo}`
  padding_size=$[2031616 - $bl_size]

  f_PADDING=${outdir_product_release_spi}/dummy.bin
  dd if=/dev/zero of=$f_PADDING bs=1 count=$padding_size
  cat $f_PADDING >> $f_spi_combo
  rm $f_PADDING
}

#
# Preparation
#
basedir_tools=${CONFIG_SYNA_SDK_PATH}/${CONFIG_TOOLS_BIN_PATH}
outdir_subimg_intermediate=${CONFIG_SYNA_SDK_OUT_TARGET_PATH}/obj/PACKAGING/subimg_intermediate
workdir_product_config=${CONFIG_SYNA_SDK_PRODUCT_PATH}/${CONFIG_PRODUCT_NAME}
opt_bindir_host=${CONFIG_SYNA_SDK_OUT_HOST_REL_PATH}
mkdir -p ${outdir_subimg_intermediate}

### SPI Flash Type ###
source ${script_dir}/spi_flash_type.bashrc

### Handle version table ###
source ${script_dir}/spi_version_table.bashrc

#
# Generate single subimage (for eng only)
#
if [ $# -eq 2 ]; then
  flag=${1}
  singleimage=${2}
  if [ "is${flag}" = "issingle" ]; then
    if [ "is${singleimage}" != "is" ]; then
      echo "pack ${singleimage} start"
      source ${basedir_script_subimg}/${singleimage}/common.bashrc
      source ${basedir_script_subimg}/${singleimage}/spi.bashrc
      echo "pack ${singleimage} done"
      exit 0
    fi
  fi
fi

#
# Generate subimages
#

### Preboot ###
source ${basedir_script_subimg}/preboot/common.bashrc
source ${basedir_script_subimg}/preboot/spi.bashrc

### TEE ###
source ${basedir_script_subimg}/tee/common.bashrc
source ${basedir_script_subimg}/tee/spi.bashrc

### Bootloader ###
source ${basedir_script_subimg}/bootloader/common.bashrc
source ${basedir_script_subimg}/bootloader/spi.bashrc

### Kernel/RAMDISK ###
source ${basedir_script_subimg}/linux_bootimgs/common.bashrc
source ${basedir_script_subimg}/linux_bootimgs/spi.bashrc

### Filesystem ###


#
# Generate SPI packages
#
product_dir=${CONFIG_SYNA_SDK_PRODUCT_PATH}/${CONFIG_PRODUCT_NAME}
outdir_product_release=${CONFIG_SYNA_SDK_OUT_TARGET_PATH}/release
outdir_product_release_spi=${outdir_product_release}/spi
mkdir -p ${outdir_product_release_spi}

genx_spi_suboot_combo $outfile_preboot_subimg $outfile_tee_subimg $outfile_bootloader_subimg ${outdir_product_release_spi}/spi_suboot.bin
cp ${outfile_linuxbootimgs_subimg} ${outdir_product_release_spi}/boot.subimg


### Preboot ###

### TEE ###

### Bootloader ###

### Linux Kernel ###

### Filesystems ###

