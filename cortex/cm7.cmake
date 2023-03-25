# Cortex M7 based flags for compilation and linking
set(cpu_flag "-mcpu=cortex-m7" CACHE STRING "Cortex CPU")
set(cpu_mode "-mthumb" CACHE STRING "ARM Mode")
set(ac6_target "--target=arm-arm-none-eabi" CACHE STRING "AC6 Target")
set(fpu_type "-mfpu=fpv5-d16" CACHE STRING "Floating Point Type")
set(float_abi "-mfloat-abi=hard" CACHE STRING "ABI For floating point")
set(cpu_link_flags "--cpu Cortex-M7.fp.dp" CACHE STRING "CPU linker flag")
set(llvm_config_file "--config armv7em_hard_fpv5_d16.cfg" CACHE STRING "LLVM configuration file")
