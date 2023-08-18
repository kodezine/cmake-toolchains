# This file setups a new static libstm32cubexx.a library from all sources available
project(
    ${STM32CubeXX}
    VERSION     0.0.1
    LANGUAGES   C ASM CXX
    DESCRIPTION "Hardware Abstraction Layer for ${STM32_DEVICE}"
)

if(NOT (CMAKE_SYSTEM_PROCESSOR STREQUAL "arm"))
    message(FATAL_ERROR "${PROJECT_NAME} can only compile with a suitable ARM cross compiler; no target build.")
endif()
if(NOT DEFINED STM32_DEVICE)
    message(FATAL_ERROR "${PROJECT_NAME} can only compile with a STM32 device definition")
endif()
if(NOT DEFINED ARMCMSIS_DEVICE)
    message(FATAL_ERROR "${PROJECT_NAME} can only compile with a valid ARMCMx definition")
endif()

# Check for valid paths to Cube Drivers used in this file
if((NOT EXISTS ${st_CMSIS_DIR}) OR (NOT EXISTS ${st_HAL_Driver_DIR}))
    message(FATAL_ERROR "${PROJECT_NAME} can only compile if the STM32CubeXX is properly set")
endif()

# the configuration of hal should be available in all cases
# if it is not provided, we use ALL the available drivers in the default configuration
if(NOT DEFINED STM32_HAL_CONFIGURATION)
    message(STATUS "${PROJECT_NAME} will use all available HAL layer artefacts")
    configure_file(${st_HAL_Driver_DIR}/Inc/stm32${LOWERCASE_STM32_TYPE}xx_hal_conf_template.h ${st_HAL_Driver_DIR}/Inc/stm32${LOWERCASE_STM32_TYPE}xx_hal_conf.h COPYONLY)
else()
    message(STATUS "${PROJECT_NAME} will use the provided HAL Configuration file")
    configure_file(${STM32_HAL_CONFIGURATION} ${st_HAL_Driver_DIR}/Inc/stm32${LOWERCASE_STM32_TYPE}xx_hal_conf.h COPYONLY)
endif()

set(cmsis_DEVICE_INCLUDE_DIR "${cmsis_SOURCE_DIR}/Device/ARM/${ARMCMSIS_DEVICE}/Include" CACHE STRING "Path to ARM Device from standard CMSIS")
set(cmsis_CORE_INCLUDE_DIR "${cmsis_SOURCE_DIR}/CMSIS/Core/Include" CACHE STRING "Path to CMSIS core includes")

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)
include(CMakePrintHelpers)

add_library(${PROJECT_NAME} STATIC)
add_library(${PROJECT_NAME}::framework ALIAS ${PROJECT_NAME})

# Get the STM32 HAL and CMSIS drivers from STM GitHub pages
set(st_CMSIS_DRV_INCLUDE_DIR "${st_CMSIS_DIR}/Device/ST/STM32${UPPERCASE_STM32_TYPE}xx/Include")
set(st_HAL_DRV_INCLUDE_DIR "${st_HAL_Driver_DIR}/Inc")
set(st_HAL_DRV_INCLUDE_LEGACY_DIR "${st_HAL_DRV_INCLUDE_DIR}/Legacy")
set(st_HAL_DRV_SOURCE_DIR "${st_HAL_Driver_DIR}/Src")
# USE OF GLOB TO MAKE IT USEFUL FOR FUTURE
file(GLOB st_HAL_DRV_SOURCES ${st_HAL_DRV_SOURCE_DIR}/*.c)
file(GLOB ${PROJECT_NAME}_PUBLIC_HEADERS ${st_HAL_DRV_INCLUDE_DIR}/*.h)

# exclude all templates from the library
list(FILTER st_HAL_DRV_SOURCES EXCLUDE REGEX "template")
list(FILTER st_HAL_DRV_SOURCES EXCLUDE REGEX "ll")
list(FILTER ${PROJECT_NAME}_PUBLIC_HEADERS EXCLUDE REGEX "template")
list(FILTER ${PROJECT_NAME}_PUBLIC_HEADERS EXCLUDE REGEX "ll")

target_sources(${PROJECT_NAME}
    PRIVATE
    ${st_HAL_DRV_SOURCES}
)

target_include_directories(${PROJECT_NAME}
    PUBLIC
        $<BUILD_INTERFACE:${cmsis_CORE_INCLUDE_DIR}>
        $<BUILD_INTERFACE:${cmsis_DEVICE_INCLUDE_DIR}>
        $<BUILD_INTERFACE:${st_HAL_DRV_INCLUDE_DIR}>
        $<BUILD_INTERFACE:${st_HAL_DRV_INCLUDE_LEGACY_DIR}>
        $<BUILD_INTERFACE:${st_CMSIS_DRV_INCLUDE_DIR}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}>
)

target_compile_definitions(${PROJECT_NAME}
    PUBLIC
        USE_HAL_DRIVER
        ${STM32_DEVICE}
#        __UVISION_VERSION="537"
#        _RTE_
)

set_target_properties(${PROJECT_NAME}
    PROPERTIES
        C_STANDARD          11
        C_STANDARD_REQUIRED ON
        C_EXTENSIONS        OFF
        PUBLIC_HEADER       "${${PROJECT_NAME}_PUBLIC_HEADERS}"
        EXPORT_NAME         framework
)

write_basic_package_version_file(${PROJECT_NAME}ConfigVersion.cmake
    VERSION       ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion
)

target_link_libraries(${PROJECT_NAME}
    INTERFACE
    cmsis-core
)

setTargetCompileOptions(PROJECT_NAME)

# CPACK begins here
install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION bin)
set(CPACK_BINARY_7Z ON)
set(CPACK_BINARY_NSIS OFF)
include(CPack)
