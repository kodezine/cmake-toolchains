# This brings the HAL and CMSIS from ST GitHub repos
# only sources are fetched, configuration should be done by the master script

include(CMakePrintHelpers)
include(FetchContent)

set(GITHUB_BRANCH_ST_CMSIS "2.3.7")
set(GITHUB_BRANCH_ST_CMSIS_MD5 "8c2bb17d4cf7384ba0b7e07fcfa40344")
cmake_print_variables(GITHUB_BRANCH_ST_CMSIS)

FetchContent_Declare(
    st_CMSIS                             # Recommendation: Stick close to the original name.
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
    URL https://github.com/STMicroelectronics/cmsis_device_f0/archive/refs/tags/v${GITHUB_BRANCH_ST_CMSIS}.tar.gz
    URL_HASH MD5=${GITHUB_BRANCH_ST_CMSIS_MD5}
)

FetchContent_GetProperties(st_CMSIS)

if(NOT st_CMSIS_POPULATED)
    FetchContent_Populate(st_CMSIS)
endif()
