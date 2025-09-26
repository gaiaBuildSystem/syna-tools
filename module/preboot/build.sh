# POSIX shell script: preboot build

. build/header.rc

if [ "is${CONFIG_GENX_MCU}" = "isy" ]; then
  . build/module/preboot/build_preboot_mcu.sh
else
  . build/module/preboot/build_preboot.sh
fi
