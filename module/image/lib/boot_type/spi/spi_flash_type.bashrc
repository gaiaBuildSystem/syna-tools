# Bash script: boot_type: SPI: spi_flash_type

### Analyzing config file ###
f_flash_cfg=${workdir_product_config}/flash_type.cfg
[ -f $f_flash_cfg ]

list_cfgs=$(cat $f_flash_cfg)

for c in $list_cfgs; do
  declare v=$(expr $c : "^spi_\(.*=.*\)")

  if [ "x$v" != "x" ]; then
    param_name=$(echo $v | cut -d = -f 1)
    param_val=$(echo $v | cut -d = -f 2)

    case "$param_name" in
      "page_size") spi_param_page_size=${param_val} ;;
      "block_size") spi_param_block_size=${param_val} ;;
      "boot_part_size") spi_param_boot_part_size=${param_val} ;;
      "total_size") spi_param_total_size=${param_val} ;;
      *) /bin/false ;;
    esac
    unset param_name
    unset param_val
  fi
  unset v
done
unset list_cfgs

### Check SPI NOR parameters ###
spi_param_total_blocks=$(( ${spi_param_total_size}/${spi_param_block_size} ))
spi_param_pages_per_block=$(( ${spi_param_block_size}/${spi_param_page_size} ))

[ $(( ${spi_param_block_size}*${spi_param_total_blocks} )) -eq ${spi_param_total_size} ]
[ $(( ${spi_param_page_size}*${spi_param_pages_per_block} )) -eq ${spi_param_block_size} ]
