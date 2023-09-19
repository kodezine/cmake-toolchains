include(CMakePrintHelpers)

if(($ENV{CORTEX_TYPE} STREQUAL "CM0") OR
   ($ENV{CORTEX_TYPE} STREQUAL "CM4F") OR
   ($ENV{CORTEX_TYPE} STREQUAL "CM7"))
    include(${CMAKE_CURRENT_LIST_DIR}/cortex/${CORTEX_TYPE}.cmake)
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
cmake_path(SET TC_SIZ_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/llvm-size${TC_POSTFIX}")

# set target compiler triplet (throws error otherwise)
set(FLAGS "${llvm_config_file}" CACHE STRING "Compiler flags")
set(ASM_FLAGS                       "-x assembler-with-cpp")

set(CMAKE_C_COMPILER                ${TC___C_EXEC} ${FLAGS})
set(CMAKE_ASM_COMPILER              ${TC___C_EXEC} ${ASM_FLAGS})
set(CMAKE_CXX_COMPILER              ${TC_CXX_EXEC} ${FLAGS} ${CPP_FLAGS})
set(CMAKE_OBJCOPY                   ${TC_ELF_EXEC})
set(CMAKE_SIZE                      ${TC_SIZ_EXEC})

set(CMAKE_EXECUTABLE_SUFFIX_ASM     ".elf")
set(CMAKE_EXECUTABLE_SUFFIX_C       ".elf")
set(CMAKE_EXECUTABLE_SUFFIX_CXX     ".elf")
set(CMAKE_EXECUTABLE_SUFFIX         ".elf")
# Upfront configured for target compilier triplet for compiler checks
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

include(${CMAKE_CURRENT_LIST_DIR}/common/clang.cmake)
