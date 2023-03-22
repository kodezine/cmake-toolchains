# Important to specify system name
set(CMAKE_SYSTEM_NAME Generic)

# The system processor is of ARM Family; makes the CMSIS happy
set(CMAKE_SYSTEM_PROCESSOR ARM)

# Not so important to specify version number
set(CMAKE_SYSTEM_VERSION 1)

# Specify toolchain prefix
set(TC_PREFIX "arm-none-eabi-")
IF(WIN32)
    set (TC_POSTFIX ".exe")
ELSE()
    set (TC_POSTFIX "")
ENDIF()

# Set GCC type
add_definitions(
    -DCOMPILER_GCC
)

# Specify location of toolchain root folder
message(CHECK_START "Searching for ARM_GCC_ROOT_FOLDER")
if(NOT EXISTS "$ENV{ARM_GCC_ROOT_FOLDER}")
    message(CHECK_FAIL "not found.")
    message(FATAL_ERROR "No valid compiler for this toolchain found, aborting!")
else()
    message(CHECK_PASS "found ... \"$ENV{ARM_GCC_ROOT_FOLDER}\"")
    set(TC_ROOT_FOLDER "$ENV{ARM_GCC_ROOT_FOLDER}")
endif()

# Exports the compile options for each file as compile_commands.json
set (CMAKE_EXPORT_COMPILE_COMMANDS ON)

# set toolchain (TC) path independent of host file system
cmake_path(SET TC_PREFIX_PATH NORMALIZE "${TC_ROOT_FOLDER}/bin")
cmake_path(SET TC___C_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/${TC_PREFIX}gcc${TC_POSTFIX}")
cmake_path(SET TC_CXX_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/${TC_PREFIX}g++${TC_POSTFIX}")
cmake_path(SET TC_GDB_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/${TC_PREFIX}gdb${TC_POSTFIX}")
cmake_path(SET TC_OBJ_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/${TC_PREFIX}objcopy${TC_POSTFIX}")
cmake_path(SET TC_SIZ_EXEC NORMALIZE "${TC_ROOT_FOLDER}/bin/${TC_PREFIX}size${TC_POSTFIX}")

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
# Specify cross compiler
set(CMAKE_C_COMPILER    ${TC___C_EXEC})
set(CMAKE_CXX_COMPILER  ${TC_CXX_EXEC})
set(DEBUGGER            ${TC_GDB_EXEC})

# Compiler cache
set(CMAKE_CXX_COMPILER  ${CMAKE_CXX_COMPILER}   CACHE FILEPATH "C++ Compiler")
set(CMAKE_C_COMPILER    ${CMAKE_C_COMPILER}     CACHE FILEPATH "C   Compiler")

set(CMAKE_OBJCOPY       ${TC_OBJ_EXEC}          CACHE INTERNAL "objcopy tool")
set(CMAKE_SIZE_UTIL     ${TC_SIZ_EXEC}          CACHE INTERNAL "size tool")

# Search for programs in the build host directories
set(CMAKE_FIND_ROOT_PATH "${TC_ROOT_FOLDER}")
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# for libraries and headers in the target directories
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# Specify cross compiler for building CMSIS

set(CMAKE_PREFIX_PATH ${TC_PREFIX_PATH})

# Get the asm flags
SET(CMAKE_ASM_FLAGS "${CFLAGS} -x assembler-with-cpp")

# Following functions required for CMSIS to build
function(compilerVersion)
    execute_process(COMMAND "${CMAKE_C_COMPILER}" -dumpversion
        OUTPUT_VARIABLE CVERSION
        ERROR_VARIABLE CVERSION
    )
    SET(COMPILERVERSION ${CVERSION} PARENT_SCOPE)
endfunction()

# Function to set compiler options (Private)
function(setTargetCompileOptions PROJECTNAME)
    target_compile_options( ${${PROJECTNAME}}
    PUBLIC
    # MCU related flags
        -mcpu=cortex-m7
        -mthumb
        -mfpu=fpv5-d16
        -mfloat-abi=hard
    # Compiler options
    # Other options
    )
endfunction(setTargetCompileOptions)

# Function to set linker options (Private)
function(setTargetLinkOptions PROJECTNAME)
    target_link_options( ${${PROJECTNAME}}
    PUBLIC
    # MCU related flags
        -mcpu=cortex-m7
        -mthumb
        -mfpu=fpv5-d16
        -mfloat-abi=hard
    # Debug options
    # Compiler Options
        -g
        -Wl,-Map=${${PROJECTNAME}}.map -Xlinker --cref
        -Wl,--gc-sections
        -Wl,-z,defs
        -Wl,--print-memory-usage
        --specs=nosys.specs
        --specs=nano.specs
        #-nodefaultlibs Can Not Compile without standard libraries
        -lm
        -lc
        -lgcc
        -L${${${PROJECTNAME}}_LINKER_PATH}
        -T${${${PROJECTNAME}}_LINKER_SCRIPT}
    )
    message(STATUS "Startup file ${${${PROJECTNAME}}_STARTUP_FILE}")
    message(STATUS "Linking with ${${${PROJECTNAME}}_LINKER_PATH}/${${${PROJECTNAME}}_LINKER_SCRIPT}")
endfunction(setTargetLinkOptions)

# Function to convert the output to hex from axf
function(convertELF_BIN_HEX target)
    add_custom_command(TARGET ${target}${SUFFIX} POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -Oihex "${CMAKE_CURRENT_BINARY_DIR}/${target}${CMAKE_EXECUTABLE_SUFFIX}" "${CMAKE_CURRENT_BINARY_DIR}/${target}.hex"
        COMMAND ${CMAKE_OBJCOPY} -Obinary "${CMAKE_CURRENT_BINARY_DIR}/${target}${CMAKE_EXECUTABLE_SUFFIX}" "${CMAKE_CURRENT_BINARY_DIR}/${target}.bin"
        COMMAND ${CMAKE_SIZE_UTIL} -B "${CMAKE_CURRENT_BINARY_DIR}/${target}${CMAKE_EXECUTABLE_SUFFIX}"
    )
endfunction(convertELF_BIN_HEX)
