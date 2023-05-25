# overarching HAL and CMSIS driver repo fetching mechanism for STM32 microcontrollers

if(${STM32_TYPE} STREQUAL "f0")
    include(${CMAKE_CURRENT_LIST_DIR}/hal_${STM32_TYPE}/st_CMSIS.cmake)
    include(${CMAKE_CURRENT_LIST_DIR}/hal_${STM32_TYPE}/st_HAL.cmake)
else()
message(FATAL_ERROR "STM Drivers can not be defined ")
endif()
