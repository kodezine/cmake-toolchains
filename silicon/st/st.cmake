# overarching HAL and CMSIS driver repo fetching mechanism for STM32 microcontrollers

if(${STM32_TYPE} STREQUAL "f0")
    include(${CMAKE_CURRENT_LIST_DIR}/hal_${STM32_TYPE}/st_CMSIS.cmake)
    include(${CMAKE_CURRENT_LIST_DIR}/hal_${STM32_TYPE}/st_HAL.cmake)

    # Get the CMSIS5 independent library from ARM CMSIS GitHub pages
    include(${cmake-toolchains_SOURCE_DIR}/frameworks/lib_cmsis.cmake)
    # Add stm32 drivers for each defined STM32 Device
    if(${STM32_DEVICE} STREQUAL "STM32F072xB")
        #include(${CMAKE_CURRENT_LIST_DIR}/hal_${STM32_TYPE}/lib_st_${STM32_TYPE}_hal.cmake)
        configure_file(${CMAKE_CURRENT_LIST_DIR}/hal_${STM32_TYPE}/lib_st_${STM32_TYPE}_hal.cmake ${CMAKE_CURRENT_LIST_DIR}/hal_${STM32_TYPE}/CMakeLists.txt COPYONLY)
        add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/hal_${STM32_TYPE})
    endif()
else()
    message(FATAL_ERROR "STM Drivers can not be defined ")
endif()
