# Bash script: boot_type: XSPI: xspi_flash_type

### Check EMMC parameters ###
xspi_param_total_blocks=$(( ${CONFIG_XSPI_TOTAL_SIZE}/${CONFIG_XSPI_BLOCK_SIZE} ))

[ $(( ${CONFIG_XSPI_BLOCK_SIZE}*${xspi_param_total_blocks} )) -eq ${CONFIG_XSPI_TOTAL_SIZE} ]
