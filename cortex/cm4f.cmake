# Cortex M4F based flags for compilation and linking
set(cpu_flag "-mcpu=cortex-m4" CACHE STRING "Cortex CPU")
set(cpu_mode "-mthumb" CACHE STRING "ARM Mode")
set(ac6_target "--target=arm-arm-none-eabi" CACHE STRING "AC6 Target")
set(ac6_link_flag "--cpu Cortex-M4F")
set(fpu_type "-mfpu=fpv4-d16" CACHE STRING "Floating Point Type")
set(float_abi "-mfloat-abi=hard" CACHE STRING "ABI For floating point")
set(llvm_config_file "--config armv7em_hard_fpv4_d16.cfg" CACHE STRING "LLVM configuration file")
