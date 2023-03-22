# Cortex M7 based flags for compilation and linking
set(cpu_flag "cortex-m7" CACHE STRING "Cortex CPU")
set(ac6_target "arm-arm-none-eabi" CACHE STRING "AC6 Target")
set(fpu_type "fpv5-d16" CACHE STRING "Floating Point Type")
set(float_abi "hard" CACHE STRING "ABI For floating point")
set(cpu_link_flags "Cortex-M7.fp.dp" CACHE STRING "CPU linker flag")
set(llvm_config_file "armv7em_hard_fpv5_d16.cfg" CACHE STRING "LLVM configuration file")
