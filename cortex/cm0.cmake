# Cortex M0 based flags for compilation and linking
set(cpu_flag "-mcpu=cortex-m0" CACHE STRING "Cortex CPU")
set(cpu_mode "-mthumb" CACHE STRING "ARM Mode")
set(ac6_target "--target=arm-arm-none-eabi" CACHE STRING "AC6 Target")
set(fpu_type "")
set(float_abi "")
set(llvm_config_file "--config armv6m_soft_nofp_semihost.cfg" CACHE STRING "LLVM configuration")
