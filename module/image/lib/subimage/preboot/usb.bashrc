# Bash script: subimage: preboot: usb

### Constants and variables ###

preboot_outdir_build_release="${outdir_preboot_release}/intermediate/release"

### Copy pre-built binary of preboot ###
### eROM ###
cp -ad ${preboot_outdir_build_release}/erom.bin ${outdir_subimg_intermediate}/

### BCM Kernel ###
cp -ad ${preboot_outdir_build_release}/K0_BOOT_store.bin ${outdir_subimg_intermediate}/
cp -ad ${preboot_outdir_build_release}/K0_TEE_store.bin ${outdir_subimg_intermediate}/
cp -ad ${preboot_outdir_build_release}/K1_BOOT_A_store.bin ${outdir_subimg_intermediate}/
cp -ad ${preboot_outdir_build_release}/K1_BOOT_B_store.bin ${outdir_subimg_intermediate}/
cp -ad ${preboot_outdir_build_release}/K1_TEE_A_store.bin ${outdir_subimg_intermediate}/
cp -ad ${preboot_outdir_build_release}/bcm_kernel.bin ${outdir_subimg_intermediate}/
cp -ad ${preboot_outdir_build_release}/K1_TEE_B_store.bin ${outdir_subimg_intermediate}/
cp -ad ${preboot_outdir_build_release}/K1_TEE_C_store.bin ${outdir_subimg_intermediate}/
cp -ad ${preboot_outdir_build_release}/K1_TEE_D_store.bin ${outdir_subimg_intermediate}/

### Boot Monitor ###
cp -ad ${preboot_outdir_build_release}/boot_monitor.bin ${outdir_subimg_intermediate}/

### SCS Data Parameter ###
cp -ad ${preboot_outdir_build_release}/scs_data_param.sign ${outdir_subimg_intermediate}/

### Sysinit ###
cp -ad ${preboot_outdir_build_release}/sysinit_en.bin ${outdir_subimg_intermediate}/

### Miniloader ###
cp -ad ${preboot_outdir_build_release}/miniloader_en.bin ${outdir_subimg_intermediate}/
