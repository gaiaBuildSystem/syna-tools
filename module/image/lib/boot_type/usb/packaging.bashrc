# Bash script: boot_type: usb

#
# Preparation
#
basedir_tools=${CONFIG_SYNA_SDK_PATH}/${CONFIG_TOOLS_BIN_PATH}
outdir_subimg_intermediate=${CONFIG_SYNA_SDK_OUT_TARGET_PATH}/obj/PACKAGING/subimg_intermediate
workdir_product_config=${CONFIG_SYNA_SDK_PRODUCT_PATH}/${CONFIG_PRODUCT_NAME}
mkdir -p ${outdir_subimg_intermediate}

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
      source ${basedir_script_subimg}/${singleimage}/usb.bashrc
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
source ${basedir_script_subimg}/preboot/usb.bashrc

### TEE ###
source ${basedir_script_subimg}/tee/common.bashrc
source ${basedir_script_subimg}/tee/usb.bashrc

### Bootloader ###
source ${basedir_script_subimg}/bootloader/common.bashrc
source ${basedir_script_subimg}/bootloader/usb.bashrc

### Linux Kernel ###
source ${basedir_script_subimg}/linux_bootimgs/common.bashrc
source ${basedir_script_subimg}/linux_bootimgs/usb.bashrc

### Filesystem ###


#
# Generate USB packages
#
product_dir=${CONFIG_SYNA_SDK_PRODUCT_PATH}/${CONFIG_PRODUCT_NAME}
outdir_product_release=${CONFIG_SYNA_SDK_OUT_TARGET_PATH}/release
outdir_product_release_usb=${outdir_product_release}/usb
mkdir -p ${outdir_product_release_usb}

### Preboot ###
if [ -f ${outdir_subimg_intermediate}/miniloader_en.bin ]; then
  cp ${outdir_subimg_intermediate}/erom.bin ${outdir_product_release_usb}/gen3_erom.bin.usb -f
  ### gen3_scs.bin.usb ###
  cat ${outdir_subimg_intermediate}/K0_BOOT_store.bin ${outdir_subimg_intermediate}/K0_TEE_store.bin \
      ${outdir_subimg_intermediate}/K1_BOOT_A_store.bin ${outdir_subimg_intermediate}/K1_BOOT_B_store.bin \
      ${outdir_subimg_intermediate}/K1_TEE_A_store.bin > ${outdir_product_release_usb}/gen3_scs.bin.usb
  ### gen3_bkl.bin.usb ###
  cat ${outdir_subimg_intermediate}/K0_BOOT_store.bin ${outdir_subimg_intermediate}/K0_TEE_store.bin \
      ${outdir_subimg_intermediate}/K1_BOOT_A_store.bin ${outdir_subimg_intermediate}/K1_BOOT_B_store.bin \
      ${outdir_subimg_intermediate}/K1_TEE_A_store.bin ${outdir_subimg_intermediate}/bcm_kernel.bin \
      ${outdir_subimg_intermediate}/K1_TEE_B_store.bin ${outdir_subimg_intermediate}/K1_TEE_C_store.bin \
      ${outdir_subimg_intermediate}/K1_TEE_D_store.bin > ${outdir_product_release_usb}/gen3_bkl.bin.usb
  cp ${outdir_subimg_intermediate}/boot_monitor.bin ${outdir_product_release_usb}/gen3_boot_monitor.bin.usb -f
  cp ${outdir_subimg_intermediate}/scs_data_param.sign ${outdir_product_release_usb}/gen3_scs_param.bin.usb -f
  cp ${outdir_subimg_intermediate}/sysinit_en.bin ${outdir_product_release_usb}/gen3_sysinit.bin.usb -f
  cp ${outdir_subimg_intermediate}/miniloader_en.bin ${outdir_product_release_usb}/gen3_miniloader.bin.usb -f
fi

### TEE ###
if [ -f ${outdir_subimg_intermediate}/tee.subimg ]; then
  cp ${outdir_subimg_intermediate}/tee.subimg ${outdir_product_release_usb}/gen3_tzk.bin.usb
  dd if=${outdir_product_release_usb}/gen3_tzk.bin.usb of=${outdir_product_release_usb}/gen3_tzk.bin.usb.header bs=1 count=512
fi

### Bootloader ###
if [ -f ${outdir_subimg_intermediate}/bootloader.subimg ]; then
  cp ${outdir_subimg_intermediate}/bootloader.subimg ${outdir_product_release_usb}/gen3_uboot.bin.usb
  dd if=${outdir_product_release_usb}/gen3_uboot.bin.usb of=${outdir_product_release_usb}/gen3_uboot.bin.usb.header bs=1 count=512
fi

### Linux Kernel ###
if [ -f ${outdir_subimg_intermediate}/Image.gz ]; then
  cp ${outdir_subimg_intermediate}/Image.gz ${outdir_product_release_usb}/Image.gz
fi

opt_linux_dts=${CONFIG_LINUX_DTS//,/ }
echo "${opt_linux_dts}"
if [ -d ${outdir_subimg_intermediate}/dtbs ]; then
for d in ${opt_linux_dts}; do
  cp -fv ${outdir_subimg_intermediate}/dtbs/${d}.dtb ${outdir_product_release_usb}/
done
fi

### Filesystems ###
if [ -f ${CONFIG_SYNA_SDK_OUT_TARGET_PATH}/ramdisk.cpio.xz ]; then
  cp ${CONFIG_SYNA_SDK_OUT_TARGET_PATH}/ramdisk.cpio.xz ${outdir_product_release_usb}/ramdisk.cpio.xz
fi

