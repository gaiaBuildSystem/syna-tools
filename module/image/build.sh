#!/bin/bash

source build/header.rc
source build/chip.rc
source build/security.rc

moduledir=${topdir}/build/module/image
[ $clean -eq 1 ] && exit 0
if [ "is${CONFIG_IMAGE_EMMC}" = "isy" ]; then
    script_dir=${moduledir}/lib/boot_type/emmc
fi
if [ "is${CONFIG_IMAGE_NAND}" = "isy" ]; then
    script_dir=${moduledir}/lib/boot_type/nand
fi
if [ "is${CONFIG_IMAGE_SPISUBOOT}" = "isy" ]; then
    script_dir=${moduledir}/lib/boot_type/spi
fi
if [ "is${CONFIG_IMAGE_USBBOOT}" = "isy" ]; then
    script_dir=${moduledir}/lib/boot_type/usb
fi
if [ "is${CONFIG_IMAGE_XSPI}" = "isy" ]; then
    script_dir=${moduledir}/lib/boot_type/xspi
fi

basedir_script_subimg=${moduledir}/lib/subimage

source ${script_dir}/packaging.bashrc
