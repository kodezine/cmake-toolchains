include(CMakePrintHelpers)
include(FetchContent)

# overarching HAL and CMSIS driver repo fetching mechanism for STM32 microcontrollers
if ((NOT DEFINED STM32_TYPE) OR (NOT DEFINED STM32_DEVICE) OR (NOT DEFINED ENV{CORTEX_TYPE}))
    message(FATAL_ERROR "This script needs a valid STM32 Family type and device defined to work with.")
endif()

# the variable value should be always upper case
string (TOUPPER ${STM32_TYPE} UPPERCASE_STM32_TYPE)
string (TOLOWER ${STM32_TYPE} LOWERCASE_STM32_TYPE)
# This brings the HAL and CMSIS from ST GitHub repos
# only sources are fetched, configuration should be done by the master script
if ((${UPPERCASE_STM32_TYPE} STREQUAL "F0") OR (${UPPERCASE_STM32_TYPE} STREQUAL "H7"))
    set(STM32CUBEF0_MD5HASH "b39a990ccad47256e0a99b2b630a65b0")
    set(STM32CUBEH7_MD5HASH "7457fb89c6a251167c968d169245b354")
    set(STM32CubeXX STM32Cube${UPPERCASE_STM32_TYPE})
    set(GITHUB_BRANCH_${STM32CubeXX} "v1.11.1")
    set(GITHUB_BRANCH_${STM32CubeXX}_MD5 ${STM32CUBE${UPPERCASE_STM32_TYPE}_MD5HASH})
    cmake_print_variables(GITHUB_BRANCH_${STM32CubeXX})

    FetchContent_Declare(
        cubexx                             # Recommendation: Stick close to the original name.
        DOWNLOAD_EXTRACT_TIMESTAMP TRUE
        URL https://github.com/STMicroelectronics/${STM32CubeXX}/archive/refs/tags/${GITHUB_BRANCH_${STM32CubeXX}}.tar.gz
        URL_HASH MD5=${GITHUB_BRANCH_${STM32CubeXX}_MD5}
    )

    FetchContent_GetProperties(cubexx)

    if(NOT cubexx_POPULATED)
        FetchContent_Populate(cubexx)
    endif()
    # Get the CMSIS5 independent library from ARM CMSIS GitHub pages
    include(${cmake-toolchains_SOURCE_DIR}/frameworks/ARM_CMSIS/arm_cmsis.cmake)

    include(${cmake-toolchains_SOURCE_DIR}/frameworks/ARM_CMSIS_DSP/arm_cmsis_dsp.cmake)
    # use the device family to set a cache variable for ARM Cortex Mx family here
    set (ARMCMSIS_DEVICE ARM$ENV{CORTEX_TYPE} CACHE STRING "CMSIS Arm Cortex Device type to match folder" FORCE)
    cmake_print_variables(ARMCMSIS_DEVICE)
else()
    message(FATAL_ERROR "STM Drivers can not be defined ")
endif()

# Add stm32 drivers for STM32 Device
if ((${STM32_DEVICE} STREQUAL "STM32F031x6") OR
    (${STM32_DEVICE} STREQUAL "STM32F072xB") OR
    (${STM32_DEVICE} STREQUAL "STM32H7A3xxQ"))
    set(st_CMSIS_DIR "${cubexx_SOURCE_DIR}/Drivers/CMSIS" CACHE PATH "Path to STM32CubeXX CMSIS folder")
    set(st_HAL_Driver_DIR "${cubexx_SOURCE_DIR}/Drivers/STM32${UPPERCASE_STM32_TYPE}xx_HAL_Driver" CACHE PATH "Path to STM32CubeXX Drivers folder")
    set(stm32_hal stm32${LOWERCASE_STM32_TYPE}xx_hal CACHE STRING "Prefix for HAL files")
#    cmake_print_variables(stm32_hal st_CMSIS_DIR st_HAL_Driver_DIR)
    add_subdirectory(${CMAKE_CURRENT_LIST_DIR})
else()
    message(FATAL_ERROR "${STM32_DEVICE} not supported yet.")
endif()
