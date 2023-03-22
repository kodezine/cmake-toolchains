# Following functions required for CMSIS to build
function(compilerVersion)
    execute_process(COMMAND "${CMAKE_C_COMPILER}" -dumpversion
        OUTPUT_VARIABLE CVERSION
        ERROR_VARIABLE CVERSION
    )
    set(COMPILERVERSION ${CVERSION} PARENT_SCOPE)
    cmake_print_variables(CVERSION)
    cmake_print_variables(CMAKE_C_COMPILER)
endfunction()

# Function to set compiler options (Private)
function(setTargetCompileOptions PROJECTNAME)
    target_compile_options( ${${PROJECTNAME}}
    PUBLIC
    # MCU related flags
        #-mcpu=cortex-m7
        #-mthumb
        #-mfpu=fpv5-d16
        #-mfloat-abi=hard
    # Compiler options
    # Other options
    -fdata-sections
    -ffunction-sections
    --specs=nano.specs
    -Wl,--gc-sections
    )
endfunction(setTargetCompileOptions)

# Function to set linker options (Private)
function(setTargetLinkOptions PROJECTNAME)
    target_link_options( ${${PROJECTNAME}}
    PUBLIC
    # MCU related flags
        #-mcpu=cortex-m7
        #-mthumb
        #-mfpu=fpv5-d16
        #-mfloat-abi=hard
    # Debug options
    ${FLAGS}
    # Compiler Options
        -g
        -Wl,-Map=${${PROJECTNAME}}.map -Xlinker --cref
        -Wl,--gc-sections
        -Wl,-z,defs
        -Wl,--print-memory-usage
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