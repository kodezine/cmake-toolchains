# This brings the HAL and CMSIS from ST GitHub repos
# only sources are fetched, configuration should be done by the master script

include(CMakePrintHelpers)
include(FetchContent)

set(GITHUB_BRANCH_ST_HAL "1.7.7")
cmake_print_variables(GITHUB_BRANCH_ST_HAL)

FetchContent_Declare(
    st_HAL                             # Recommendation: Stick close to the original name.
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
    URL https://github.com/STMicroelectronics/stm32f0xx_hal_driver/archive/refs/tags/v${GITHUB_BRANCH_ST_HAL}.tar.gz
    URL_HASH MD5=5fd31c52559a593dd9038c4abb4b85faeac728c6
)

FetchContent_GetProperties(st_HAL)

if(NOT st_HAL_POPULATED)
    FetchContent_Populate(st_HAL)
endif()
