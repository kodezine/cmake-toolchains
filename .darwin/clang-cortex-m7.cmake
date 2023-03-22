set(CMAKE_SYSTEM_NAME Generic)

# The system processor is of the ARM family; this makes the CMSIS happy
set(CMAKE_SYSTEM_PROCESSOR ARM)

include(CMakePrintHelpers)

# Specify toolchain postfix extension
IF(WIN32)
    set (TC_POSTFIX ".exe")
ELSE()
    set (TC_POSTFIX "")
ENDIF()

# Specify location of toolchain root folder
message(CHECK_START "Searching for LLVM_CLANG_ROOT_FOLDER")
if(NOT EXISTS "$ENV{LLVM_CLANG_ROOT_FOLDER}")
    message(CHECK_FAIL "not found.")
    message(STATUS "No valid compiler for this toolchain found, probing local!")
    set(TC_ROOT_FOLDER "/Users/sohal/LLVMEmbedded/LLVMEmbeddedToolchainForArm-17.0.0-Darwin-AArch64")
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

# set target compiler triplet (throws error otherwise)
#set(CMAKE_C_COMPILER_TARGET     "arm-none-eabihf")
#set(CMAKE_CXX_COMPILER_TARGET   "arm-none-eabihf")

set(CMAKE_C_COMPILER    "${TC___C_EXEC}")
set(CMAKE_CXX_COMPILER  "${TC_CXX_EXEC}")
set(CMAKE_ASM_COMPILER  "${TC_ASM_EXEC}")


# Upfront configured for target compilier triplet for compiler checks
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# All mandatory functions defined below
include(CMakePrintHelpers)
# Function to show compiler version
function(showCompilerVersion)
    execute_process(COMMAND "${CMAKE_C_COMPILER}" -dumpversion
        OUTPUT_VARIABLE CVERSION
        ERROR_VARIABLE CVERSION
    )
    SET(COMPILERVERSION ${CVERSION} PARENT_SCOPE)
    cmake_print_variables(CVERSION)
    cmake_print_variables(CMAKE_C_COMPILER)
    MESSAGE( STATUS "CMD_OUTPUT:" ${CVERSION})
endfunction(showCompilerVersion)

# Function to convert the output to hex from axf
function(convertELF_BIN_HEX target)
    add_custom_command(TARGET ${target}${SUFFIX} POST_BUILD
        COMMAND ${TC_ELF_EXEC} --bincombined -v --output "${CMAKE_CURRENT_BINARY_DIR}/${target}.bin" "${CMAKE_CURRENT_BINARY_DIR}/${target}.elf"
        COMMAND ${TC_ELF_EXEC} --i32combined -v --output "${CMAKE_CURRENT_BINARY_DIR}/${target}.hex" "${CMAKE_CURRENT_BINARY_DIR}/${target}.elf"
        COMMAND ${TC_ELF_EXEC} -s -v "${CMAKE_CURRENT_BINARY_DIR}/${target}.elf" > "${target}.txt"
    )
endfunction(convertELF_BIN_HEX)
