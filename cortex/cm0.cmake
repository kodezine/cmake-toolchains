# Cortex M0 based flags for compilation and linking
set(cpu_flag "cortex-m0" CACHE STRING "Cortex CPU")
set(ac6_target "arm-arm-none-eabi" CACHE STRING "AC6 Target")
set(fpu_type )
set(float_abi )
set(cpu_link_flags "Cortex-M0" CACHE STRING "Cortex CPU for linker")
set(llvm_config_file "armv6m_soft_nofp_semihost.cfg" CACHE STRING "LLVM configuration")
