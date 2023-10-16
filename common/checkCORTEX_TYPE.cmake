include(CMakePrintHelpers)
if(($ENV{CORTEX_TYPE} STREQUAL "CM0") OR
   ($ENV{CORTEX_TYPE} STREQUAL "CM4F") OR
   ($ENV{CORTEX_TYPE} STREQUAL "CM7"))
    include(${CMAKE_CURRENT_LIST_DIR}/cortex/$ENV{CORTEX_TYPE}.cmake)
else()
    message(FATAL_ERROR "Define a CORTEX TYPE in just before engaging this script")
endif()

set(CMAKE_SYSTEM_NAME Generic)

# The system processor is of the ARM family; this makes the CMSIS happy
set(CMAKE_SYSTEM_PROCESSOR arm)

# Specify toolchain postfix extension
if(WIN32)
    set(TC_POSTFIX ".exe")
endif()
