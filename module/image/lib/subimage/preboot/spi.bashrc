# Bash script: subimage: preboot: spi

spi_vt_size=2048
spi_header_size=1024

gen_preboot_subimg() {
  f_input=$1; shift

  ### Fill the gap ###
  f_len=$(stat -c %s ${f_input})
  [ ! $(( $f_len + 2048 )) -gt ${spi_param_boot_part_size} ]

  fill_length=$(( ${spi_param_boot_part_size} - ${spi_vt_size} - ${spi_header_size} - ${f_len} ))
  dd if=/dev/zero bs=$fill_length count=1 >> ${f_input}

  ### Append version table ###
  cat ${outdir_subimg_intermediate}/version_table >> ${f_input}

  ### Append to block size ###
  f_len=$(stat -c %s ${f_input})
  [ ! $f_len -gt ${spi_param_boot_part_size} ]

  fill_length=$(( ${spi_param_boot_part_size} - ${spi_header_size} - ${f_len} ))
  dd if=/dev/zero bs=$fill_length count=1 >> ${f_input}
}

### Copy pre-built binary of preboot ###
cp -ad ${outdir_preboot_release}/preboot_esmt.bin ${outfile_preboot_subimg}

gen_preboot_subimg ${outfile_preboot_subimg}
