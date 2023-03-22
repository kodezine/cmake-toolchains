include(CMakePrintHelpers)

if(CORTEX_TYPE STREQUAL "cm7")
include(./cortex/cm7.cmake)
elseif(CORTEX_TYPE STREQUAL "cm0")
include(./cortex/cm0.cmake)
else()
message(FATAL_ERROR "Define a CORTEX TYPE in just before engaging this script")
endif()

set(CMAKE_SYSTEM_NAME Generic)

# The system processor is of the ARM family; this makes the CMSIS happy
set(CMAKE_SYSTEM_PROCESSOR arm)

# Specify toolchain postfix extension
if(WIN32)
    set(TC_POSTFIX ".exe")
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
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# set target compiler triplet (throws error otherwise)
set(CMAKE_C_COMPILER_TARGET     "${ac6_target}")
set(CMAKE_CXX_COMPILER_TARGET   "${ac6_target}")

set(FLAGS "--target=${ac6_target} -mcpu=${cpu_flag} -mfpu=${fpu_type} -mfloat-abi=${float_abi}" CACHE STRING "Compile flags")
set(LINK_FLAGS "--cpu ${cpu_link_flags}" CACHE STRING "Linker flags")

set(CMAKE_C_COMPILER    ${TC___C_EXEC} ${FLAGS})
set(CMAKE_CXX_COMPILER  ${TC_CXX_EXEC} ${FLAGS})
set(CMAKE_ASM_COMPILER  ${TC_ASM_EXEC} ${FLAGS})

# Upfront configured for target compilier triplet for compiler checks
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

include(./common/ac6.cmake)
