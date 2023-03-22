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
set(CMAKE_C_COMPILER_TARGET     "arm-arm-none-eabi")
set(CMAKE_CXX_COMPILER_TARGET   "arm-arm-none-eabi")

set(CMAKE_C_COMPILER    ${TC___C_EXEC} -mcpu=cortex-m7)
set(CMAKE_CXX_COMPILER  ${TC_CXX_EXEC} -mcpu=cortex-m7)
set(CMAKE_ASM_COMPILER  ${TC_ASM_EXEC} -mcpu=cortex-m7)

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
    set(COMPILERVERSION ${CVERSION} PARENT_SCOPE)
endfunction(showCompilerVersion)

# Function to set compiler options (Private)
function(setTargetCompileOptions PROJECTNAME)
    target_compile_options( ${${PROJECTNAME}}
    PUBLIC
        --target=arm-arm-none-eabi -mcpu=cortex-m7 -mfpu=fpv5-d16
        -std=c11
        -mfloat-abi=hard
        -c
        -fno-rtti
        -funsigned-char
        -fshort-enums
        -fshort-wchar
        -masm=auto
        -gdwarf-3 # defaulting to legacy debug tables for armgdb debuggers
        -fno-ldm-stm
        -ffunction-sections
        -Wno-packed
        -Wno-missing-variable-declarations
        -Wno-missing-prototypes
        -Wno-missing-noreturn
        -Wno-sign-conversion
        -Wno-nonportable-include-path
        -Wno-reserved-id-macro
        -Wno-unused-macros
        -Wno-documentation-unknown-command
        -Wno-documentation
        -Wno-license-management
        -Wno-parentheses-equality
        -Wno-reserved-identifier
        "$<$<CONFIG:Debug>:-O1>"        # Debuggable code
    )
endfunction(setTargetCompileOptions)

# Function to set linker options (Private)
function(setTargetLinkOptions PROJECTNAME)
    target_link_options( ${${PROJECTNAME}}
        PUBLIC
        --cpu Cortex-M7.fp.dp
        --strict
        "$<$<CONFIG:Debug>:--bestdebug>"        # Debuggable code
        --scatter ${${${PROJECTNAME}}_SCATTER_PATH}/${${${PROJECTNAME}}_SCATTER_FILE}
        --summary_stderr
        --info common,debug,sizes,totals,veneers,unused,summarysizes
    )
    message(STATUS "Startup file ${${${PROJECTNAME}}_STARTUP_FILE}")
    message(STATUS "Linking with ${${${PROJECTNAME}}_SCATTER_PATH}/${${${PROJECTNAME}}_SCATTER_FILE}")
endfunction(setTargetLinkOptions)

# Function to convert the output to hex from axf
function(convertELF_BIN_HEX target)
    add_custom_command(TARGET ${target}${SUFFIX} POST_BUILD
    COMMAND ${TC_ELF_EXEC} --bincombined -v --output "${CMAKE_CURRENT_BINARY_DIR}/${target}.bin" "${CMAKE_CURRENT_BINARY_DIR}/${target}.elf"
    COMMAND ${TC_ELF_EXEC} --i32combined -v --output "${CMAKE_CURRENT_BINARY_DIR}/${target}.hex" "${CMAKE_CURRENT_BINARY_DIR}/${target}.elf"
    COMMAND ${TC_ELF_EXEC} -s -v "${CMAKE_CURRENT_BINARY_DIR}/${target}.elf" > "${target}.txt"
    )
endfunction(convertELF_BIN_HEX)

# Function to start license server
function(startLicenseServer)
    execute_process(
        COMMAND /home/build/ARM/license-tunnel.sh
        COMMAND sleep 5
        TIMEOUT 10
        COMMAND_ECHO STDOUT
    )
endfunction(startLicenseServer)

# Function to stop license server
function (stopLicenseServer)
    execute_process(
        COMMAND /home/build/ARM/license-tunnel.sh stop
        TIMEOUT 10
        COMMAND_ECHO STDOUT
    )
endfunction(stopLicenseServer)
