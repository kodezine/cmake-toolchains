
include(CMakePrintHelpers)

if($ENV{CORTEX_TYPE} STREQUAL "cm7")
    include(${CMAKE_CURRENT_LIST_DIR}/cortex/cm7.cmake)
elseif($ENV{CORTEX_TYPE} STREQUAL "cm4f")
    include(${CMAKE_CURRENT_LIST_DIR}/cortex/cm4f.cmake)
elseif($ENV{CORTEX_TYPE} STREQUAL "cm0")
    include(${CMAKE_CURRENT_LIST_DIR}/cortex/cm0.cmake)
else()
    message(FATAL_ERROR "Define a CORTEX TYPE in just before engaging this script")
endif()

set(CMAKE_SYSTEM_NAME Generic)

# The system processor is of the ARM family; this makes the CMSIS happy
set(CMAKE_SYSTEM_PROCESSOR arm)

# Let's begin with starting the license client tunnel
execute_process(
    COMMAND /home/build/ARM/license-tunnel.sh
    TIMEOUT 10
)

# Specify toolchain postfix extension
if(WIN32)
    set(TC_POSTFIX ".exe")
endif()

# Specify license variables for armclang
if(NOT EXISTS "$ENV{ARM_PRODUCT_DEF}")
    message(STATUS "Could not find ARM_PRODUCT_DEF in environment ... setting to bronze")
    set(ENV{ARM_PRODUCT_DEF} "/home/build/ARM/bronze.elmap")
else()
    cmake_print_variables($ENV{ARM_PRODUCT_DEF})
endif()

# Specify location of toolchain root folder
message(CHECK_START "Searching for ARM_CLANG_ROOT_FOLDER")
if(NOT EXISTS "$ENV{ARM_CLANG_ROOT_FOLDER}")
    message(CHECK_FAIL "not found.")
    message(FATAL_ERROR "No valid compiler for this toolchain found, aborting!")
else()
    message(CHECK_PASS "found ... \"$ENV{ARM_CLANG_ROOT_FOLDER}\"")
    set(TC_ROOT_FOLDER "$ENV{ARM_CLANG_ROOT_FOLDER}")
endif()

# Exports the compile options for each file as compile_commands.json
set (CMAKE_EXPORT_COMPILE_COMMANDS ON)

# set toolchain (TC) path independent of host file system
cmake_path(SET TC___C_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/armclang${TC_POSTFIX}")
cmake_path(SET TC_CXX_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/armclang${TC_POSTFIX}")
cmake_path(SET TC_ASM_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/armclang${TC_POSTFIX}")
cmake_path(SET TC_ELF_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/fromelf${TC_POSTFIX}")

# set target compiler triplet (throws error otherwise)
set(CMAKE_C_COMPILER_TARGET     "${ac6_target}")
set(CMAKE_CXX_COMPILER_TARGET   "${ac6_target}")

set(FLAGS "${ac6_target} ${cpu_flag} ${fpu_type} ${float_abi}" CACHE STRING "Compiler flags")
set(LINK_FLAGS "${cpu_link_flags}" CACHE STRING "Linker flags")

set(CMAKE_C_COMPILER    ${TC___C_EXEC} ${FLAGS})
set(CMAKE_CXX_COMPILER  ${TC_CXX_EXEC} ${FLAGS})
set(CMAKE_ASM_COMPILER  ${TC_ASM_EXEC} ${FLAGS})


# Upfront configured for target compilier triplet for compiler checks
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

include(${CMAKE_CURRENT_LIST_DIR}/common/ac6.cmake)