# overarching HAL and CMSIS driver repo fetching mechanism for STM32 microcontrollers

if($ENV{ST_TYPE} STREQUAL "f0")
    include(silicon/st/hal_$ENV{ST_TYPE}/st_CMSIS.cmake)
    include(silicon/st/hal_$ENV{ST_TYPE}/st_HAL.cmake)
else()
message(FATAL_ERROR "STM Drivers can not be defined ")
endif()