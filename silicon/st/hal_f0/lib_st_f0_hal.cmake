# This file setups a new static libstm32f0xx_hal.a library from all sources available
project(
    stm32f0xx_hal
    VERSION     0.0.1
    LANGUAGES   C ASM CXX
    DESCRIPTION "Hardware Abstraction Layer for STM32 F0 devices"
)

if(NOT (CMAKE_SYSTEM_PROCESSOR STREQUAL "arm"))
    message(FATAL_ERROR "${PROJECT_NAME} can only compile with a suitable ARM cross compiler; no target build.")
endif()
if(NOT DEFINED STM32_DEVICE)
    message(FATAL_ERROR "${PROJECT_NAME} can only compile with a STM32 device definition")
endif()
if(NOT DEFINED STM32_HAL_CONFIGURATION)
    message(STATUS "${PROJECT_NAME} will use all available HAL layer artefacts")
    configure_file(${st_hal_SOURCE_DIR}/Inc/${PROJECT_NAME}_conf_template.h ${st_hal_SOURCE_DIR}/Inc/${PROJECT_NAME}_conf.h COPYONLY)
endif()

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)
include(CMakePrintHelpers)

add_library(${PROJECT_NAME} STATIC EXCLUDE_FROM_ALL)
add_library(${PROJECT_NAME}::framework ALIAS ${PROJECT_NAME})

# Get the STM32 HAL and CMSIS drivers from STM GitHub pages
set(st_CMSIS_DRV_INCLUDE_DIR "${st_cmsis_SOURCE_DIR}/Include")
set(st_HAL_DRV_INCLUDE_DIR "${st_hal_SOURCE_DIR}/Inc")
set(st_HAL_DRV_INCLUDE_LEGACY_DIR "${st_HAL_DRV_INCLUDE_DIR}/Legacy")
set(st_HAL_DRV_SOURCE_DIR "${st_hal_SOURCE_DIR}/Src")
set(st_HAL_DRV_SOURCES
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_adc.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_adc_ex.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_can.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_cec.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_comp.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_cortex.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_crc.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_crc_ex.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_dac.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_dac_ex.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_dma.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_exti.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_flash.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_flash_ex.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_gpio.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_i2c.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_i2c_ex.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_i2s.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_irda.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_iwdg.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_msp_template.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_pcd.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_pcd_ex.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_pwr.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_pwr_ex.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_rcc.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_rcc_ex.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_rtc.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_rtc_ex.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_smartcard.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_smartcard_ex.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_smbus.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_spi.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_spi_ex.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_tim.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_tim_ex.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_timebase_rtc_alarm_template.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_timebase_rtc_wakeup_template.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_timebase_tim_template.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_tsc.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_uart.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_uart_ex.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_usart.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_usart_ex.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_hal_wwdg.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_ll_adc.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_ll_comp.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_ll_crc.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_ll_crs.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_ll_dac.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_ll_dma.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_ll_exti.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_ll_gpio.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_ll_i2c.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_ll_pwr.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_ll_rcc.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_ll_rtc.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_ll_spi.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_ll_tim.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_ll_usart.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_ll_usb.c
    ${st_HAL_DRV_SOURCE_DIR}/stm32f0xx_ll_utils.c
)

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
        __UVISION_VERSION="537"
        _RTE_
)

set(${PROJECT_NAME}_PUBLIC_HEADERS
    ${st_HAL_DRV_INCLUDE_DIR}/stm32_assert_template.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_adc.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_adc_ex.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_can.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_cec.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_comp.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_cortex.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_crc.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_crc_ex.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_dac.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_dac_ex.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_def.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_dma.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_dma_ex.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_exti.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_flash.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_flash_ex.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_gpio.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_gpio_ex.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_i2c.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_i2c_ex.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_i2s.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_irda.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_irda_ex.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_iwdg.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_pcd.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_pcd_ex.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_pwr.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_pwr_ex.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_rcc.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_rcc_ex.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_rtc.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_rtc_ex.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_smartcard.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_smartcard_ex.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_smbus.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_spi.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_spi_ex.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_tim.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_tim_ex.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_tsc.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_uart.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_uart_ex.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_usart.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_usart_ex.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_hal_wwdg.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_ll_adc.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_ll_bus.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_ll_comp.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_ll_cortex.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_ll_crc.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_ll_crs.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_ll_dac.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_ll_dma.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_ll_exti.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_ll_gpio.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_ll_i2c.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_ll_iwdg.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_ll_pwr.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_ll_rcc.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_ll_rtc.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_ll_spi.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_ll_system.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_ll_tim.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_ll_usart.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_ll_usb.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_ll_utils.h
    ${st_HAL_DRV_INCLUDE_DIR}/stm32f0xx_ll_wwdg.h
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

setTargetCompileOptions(PROJECT_NAME)

# CPACK begins here
install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION bin)
set(CPACK_BINARY_7Z ON)
set(CPACK_BINARY_NSIS OFF)
include(CPack)
