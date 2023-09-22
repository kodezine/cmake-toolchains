include(CMakePrintHelpers)
include(FetchContent)

set(GITHUB_BRANCH_CMSIS "5.9.0")
set(GITHUB_BRANCH_CMSIS_MD5 "6b67968b5a3540156a4bd772d899339e")
cmake_print_variables(GITHUB_BRANCH_CMSIS)

FetchContent_Declare(
    cmsis                             # Recommendation: Stick close to the original name.
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
    URL https://github.com/ARM-software/CMSIS_5/archive/refs/tags/${GITHUB_BRANCH_CMSIS}.tar.gz
    URL_HASH MD5=${GITHUB_BRANCH_CMSIS_MD5}
)

FetchContent_GetProperties(cmsis)

if(NOT cmsis_POPULATED)
    FetchContent_Populate(cmsis)
    configure_file(${CMAKE_CURRENT_LIST_DIR}/cmsisConfig.cmake ${cmsis_SOURCE_DIR}/cmsisConfig.cmake COPYONLY)
    configure_file(${CMAKE_CURRENT_LIST_DIR}/CMakeLists.cmsis.cmake ${cmsis_SOURCE_DIR}/CMakeLists.txt COPYONLY)
    add_subdirectory(${cmsis_SOURCE_DIR})
endif()
