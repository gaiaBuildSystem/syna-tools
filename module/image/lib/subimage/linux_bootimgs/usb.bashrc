# Bash script: subimage: linux_bootimgs: usb

### !!! FIXME !!! should be consolidate into single script ###

########
# Main #
########

if [ -f ${outdir_linux_release}/Image.gz ]; then
  cp ${outdir_linux_release}/Image.gz ${outdir_subimg_intermediate}/Image.gz
fi

if [ -d ${outdir_linux_release}/dtbs ]; then
  rm -rf ${outdir_subimg_intermediate}/dtbs
  cp -rf ${outdir_linux_release}/dtbs ${outdir_subimg_intermediate}/
fi
