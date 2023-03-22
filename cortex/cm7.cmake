# Cortex M7 based flags for compilation and linking
set(cpu_flag cortex-m7)
set(ac6_target arm-arm-none-eabi)
set(fpu_type fpv5-d16)
set(float_abi hard)
set(cpu_link_flags Cortex-M7.fp.dp)
set(llvm_config_file "armv7em_hard_fpv5_d16.cfg")
