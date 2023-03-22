
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
message(CHECK_START "Searching for LLVM_CLANG_ROOT_FOLDER")
if(NOT EXISTS "$ENV{LLVM_CLANG_ROOT_FOLDER}")
    message(CHECK_FAIL "not found.")
    message(FATAL_ERROR "No valid compiler for this toolchain found, aborting!")
else()
    message(CHECK_PASS "found ... \"$ENV{LLVM_CLANG_ROOT_FOLDER}\"")
    set(TC_ROOT_FOLDER "$ENV{LLVM_CLANG_ROOT_FOLDER}")
endif()

# Exports the compile options for each file as compile_commands.json
set (CMAKE_EXPORT_COMPILE_COMMANDS ON)

# set toolchain (TC) path independent of host file system
cmake_path(SET TC___C_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/clang${TC_POSTFIX}")
cmake_path(SET TC_CXX_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/clang${TC_POSTFIX}")
cmake_path(SET TC_ASM_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/clang${TC_POSTFIX}")
cmake_path(SET TC_ELF_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/llvm-objcopy${TC_POSTFIX}")

set(CMAKE_C_COMPILER    "${TC___C_EXEC}")
set(CMAKE_CXX_COMPILER  "${TC_CXX_EXEC}")
set(CMAKE_ASM_COMPILER  "${TC_ASM_EXEC}")


# Upfront configured for target compilier triplet for compiler checks
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

include(./common/ac6.cmake)