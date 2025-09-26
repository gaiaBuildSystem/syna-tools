# Bash script: subimage: tee: default


### TODO(Song) should not use flash type to decide prepending or not ###
  ### Copy pre-built binary of tee with prepending image info ###
if [ "is${CONFIG_GENX_MCU}" = "isy" ]; then
  process_cmd="cp"

  if [ "is${CONFIG_UBOOT_SPIUBOOT}" = "isy" ]; then
    truncate --size=819200 ${outdir_tee_release}/tee_en.bin
  fi
else
  process_cmd="${basedir_tools}/prepend_image_info.sh"
fi

eval "${process_cmd} ${outdir_tee_release}/tee_en.bin ${outfile_tee_subimg}"
if [ -f ${outdir_tee_release}/tee_recovery_en.bin ]; then
  eval "${process_cmd} ${outdir_tee_release}/tee_recovery_en.bin ${outfile_tee_recovery_subimg}"
fi
