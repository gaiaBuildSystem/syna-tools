# Bash script: boot_type: NAND: version table

# Generate version table
exec2run=${CONFIG_SYNA_SDK_OUT_HOST_REL_PATH}/parse_pt_xspi
[ -x ${exec2run} ]

cmd_args=""
cmd_args="${cmd_args} 101 101"
cmd_args="${cmd_args} ${CONFIG_XSPI_BLOCK_SIZE} ${CONFIG_XSPI_TOTAL_SIZE}"
cmd_args="${cmd_args} ${workdir_product_config}/xspi.pt"

cmd_args="${cmd_args} ${outdir_subimg_intermediate}/linux_params_mtdparts"
cmd_args="${cmd_args} ${outdir_subimg_intermediate}/version_table"
cmd_args="${cmd_args} ${outdir_subimg_intermediate}/subimglayout"
cmd_args="${cmd_args} ${outdir_subimg_intermediate}/xspi_part_table"
cmd_args="${cmd_args} ${outdir_subimg_intermediate}/xspi_part_list"
cmd_args="${cmd_args} ${outdir_subimg_intermediate}/xspi_image_list"

eval $exec2run "$cmd_args"

# Update CRC
exec2run=${CONFIG_SYNA_SDK_OUT_HOST_REL_PATH}/crc

cmd_args=""
cmd_args="${cmd_args} -a"
cmd_args="${cmd_args} ${outdir_subimg_intermediate}/version_table"

eval $exec2run "$cmd_args"

# Clean up
unset -v cmd_args
unset -v exec2run
