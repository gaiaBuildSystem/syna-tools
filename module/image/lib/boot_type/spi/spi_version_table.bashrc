# Bash script: boot_type: SPI: version table

# Generate version table
exec2run=${opt_bindir_host}/parse_pt
[ -x ${exec2run} ]

cmd_args=""
cmd_args="${cmd_args} 0 0"
cmd_args="${cmd_args} ${spi_param_block_size} ${spi_param_total_size}"
cmd_args="${cmd_args} ${workdir_product_config}/spi.pt"

cmd_args="${cmd_args} ${outdir_subimg_intermediate}/linux_params_mtdparts"
cmd_args="${cmd_args} ${outdir_subimg_intermediate}/version_table"
cmd_args="${cmd_args} ${outdir_subimg_intermediate}/subimglayout"

eval $exec2run "$cmd_args"

cmd_args="${cmd_args} ${outdir_subimg_intermediate}/linux_params_mtdparts"
cmd_args="${cmd_args} ${outdir_subimg_intermediate}/version_table"
cmd_args="${cmd_args} ${outdir_subimg_intermediate}/subimglayout"


# Update CRC
exec2run=${opt_bindir_host}/crc

cmd_args=""
cmd_args="${cmd_args} -a"
cmd_args="${cmd_args} ${outdir_subimg_intermediate}/version_table"

eval $exec2run "$cmd_args"

# Analyze subimg size
f_flash_subimglayout=${outdir_subimg_intermediate}/subimglayout
[ -f $f_flash_subimglayout ]

while IFS=$'\t' read -r subimg_name subimg_start_lba subimg_lba_num col col5; do
  case "$subimg_name" in
      "preboot_a") spi_preboot_end=$(($((${subimg_start_lba} + ${subimg_lba_num})) * ${spi_param_block_size})) ;;
      "tzk_a") spi_tzk_end=$(($((${subimg_start_lba} + ${subimg_lba_num})) * ${spi_param_block_size})) ;;
      "bl_a") spi_bl_end=$(($((${subimg_start_lba} + ${subimg_lba_num})) * ${spi_param_block_size})) ;;
      *) ;;
  esac
  unset subimg_name
  unset subimg_start_lba
  unset subimg_lba_num
done < "$f_flash_subimglayout"

# Clean up
unset -v cmd_args
unset -v exec2run
