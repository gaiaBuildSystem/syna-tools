# Bash script: subimage: preload_ta: emmc

#############
# Functions #
#############

out_dir_rootfs="${CONFIG_SYNA_SDK_OUT_TARGET_PATH}/${CONFIG_SYNA_SDK_OUT_ROOTFS}"
out_ta_dir="${out_dir_rootfs}/lib/optee_armtz"
fl_ta_file="1316a183-894d-43fe-9893-bb946ae103f5.ta"

get_image_aligned() {
  f_input=$1; shift
  align_size=$1; shift

  ### Check input file ###
  [ -f $f_input ]

  f_size=`stat -c %s ${f_input}`
  append_size=`expr ${align_size} - ${f_size} % ${align_size}`

  if [ ${append_size} -lt ${align_size} ]; then
    dd if=/dev/zero of=${f_input} bs=1 seek=${f_size} count=${append_size} conv=notrunc
  fi
}

generate_preload_ta_subimg() {
  ### use genimg to pack all preload TAs ###
  params=""

  if [ "is${CONFIG_BL_TA_FASTLOGO}" = "isy" ]; then
    if [ -e ${out_ta_dir}/${fl_ta_file} ]; then
      params="$params -i 03F5 -d ${out_ta_dir}/${fl_ta_file}"
    else
      echo "no Fastlogo ${fl_ta_file} under ${out_ta_dir}!!!"
      exit 1
    fi
  fi

  echo "######$params"
  ${CONFIG_SYNA_SDK_OUT_HOST_REL_PATH}/genimg -n preload_ta -A 4096 $params -o ${preload_ta_subimg}
  rm ${outdir_preload_ta}/*.header
  rm ${outdir_preload_ta}/*.header.filler
}

mkdir -p ${outdir_preload_ta}
generate_preload_ta_subimg

[ -f ${preload_ta_subimg} ]
[ -f ${outfile_bootloader_subimg} ]

# apend preload tas to 512B aligned address
get_image_aligned ${outfile_bootloader_subimg} 512

# Packaging preloadta image
cat ${preload_ta_subimg} >> ${outfile_bootloader_subimg}
