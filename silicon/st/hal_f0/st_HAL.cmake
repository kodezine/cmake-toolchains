# This brings the HAL and CMSIS from ST GitHub repos
# only sources are fetched, configuration should be done by the master script

include(CMakePrintHelpers)
include(FetchContent)

set(GITHUB_BRANCH_ST_HAL "2.3.7")
cmake_print_variables(GITHUB_BRANCH_ST_HAL)

FetchContent_Declare(
    st_HAL                             # Recommendation: Stick close to the original name.
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
    URL https://github.com/STMicroelectronics/cmsis_device_f0/releases/tag/v${GITHUB_BRANCH_ST_HAL}.tar.gz
    URL_HASH MD5=3973d99a89ac5fdf1f2593abc29a73d2981ce94a
)

FetchContent_GetProperties(st_HAL)

if(NOT st_HAL_POPULATED)
    FetchContent_Populate(st_HAL)
endif()
