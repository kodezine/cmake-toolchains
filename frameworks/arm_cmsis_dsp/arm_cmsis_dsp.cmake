include(CMakePrintHelpers)
include(FetchContent)

set(GITHUB_BRANCH_CMSIS_DSP "1.15.0")
set(GITHUB_BRANCH_CMSIS_DSP_MD5 "2354c7b28ca88735fd5d86b8754c57ee")

cmake_print_variables(GITHUB_BRANCH_CMSIS_DSP)

FetchContent_Declare(
    cmsis_dsp                          # Recommendation: Stick close to the original name.
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
    URL https://github.com/ARM-software/CMSIS-DSP/archive/refs/tags/v${GITHUB_BRANCH_CMSIS_DSP}.tar.gz
    URL_HASH MD5=${GITHUB_BRANCH_CMSIS_DSP_MD5}
)

FetchContent_GetProperties(cmsis_dsp)

if(NOT cmsis_dsp_POPULATED)
    FetchContent_Populate(cmsis_dsp)

    configure_file(${CMAKE_CURRENT_LIST_DIR}/cmsis_dspConfig.cmake ${cmsis_dsp_SOURCE_DIR}/cmsis_dspConfig.cmake COPYONLY)
    add_subdirectory(${CMAKE_CURRENT_LIST_DIR})
endif()
