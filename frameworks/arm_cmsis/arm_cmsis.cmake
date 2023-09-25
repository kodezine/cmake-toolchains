include(CMakePrintHelpers)
include(FetchContent)

set(libName "cmsis")

if ($ENV{USE_PRECOMPILED_LIBS})
    set(GITHUB_BRANCH_CMSIS "5.9.0")
    set(GITHUB_BRANCH_CMSIS_SHA3_256 "57f244324c8557347cf0564fed901efc3f09c9def1b88849eed3e23bdb38b6b5")

    FetchContent_Declare(
        ${libName}                             # Recommendation: Stick close to the original name.
        DOWNLOAD_EXTRACT_TIMESTAMP TRUE
        URL https://github.com/kodezine/cmsis-v5/releases/download/v0.1.0/${libName}-${GITHUB_BRANCH_CMSIS}-$ENV{CORTEX_TYPE}-${CMAKE_C_COMPILER_ID}-${CMAKE_C_COMPILER_VERSION}.tar.gz
        URL_HASH SHA3_256=${GITHUB_BRANCH_CMSIS_SHA3_256}
        FIND_PACKAGE_ARGS NAMES ${libName}
    )
    #FetchContent_MakeAvailable(${libName})
    message(STATUS "${libName}: Successfully extracted precompiled library from GitHub")

else ()
    set(GITHUB_BRANCH_CMSIS "5.9.0")
    set(GITHUB_BRANCH_CMSIS_MD5 "6b67968b5a3540156a4bd772d899339e")

    FetchContent_Declare(
        ${libName}                             # Recommendation: Stick close to the original name.
        DOWNLOAD_EXTRACT_TIMESTAMP TRUE
        URL https://github.com/ARM-software/CMSIS_5/archive/refs/tags/${GITHUB_BRANCH_CMSIS}.tar.gz
        URL_HASH MD5=${GITHUB_BRANCH_CMSIS_MD5}
        FIND_PACKAGE_ARGS NAMES ${libName}
    )

    FetchContent_GetProperties(${libName})

    if(NOT ${libName}_POPULATED)
        FetchContent_Populate(${libName})
        configure_file(${CMAKE_CURRENT_LIST_DIR}/${libName}Config.cmake ${${libName}_SOURCE_DIR}/${libName}Config.cmake COPYONLY)
        configure_file(${CMAKE_CURRENT_LIST_DIR}/CMakeLists.${libName}.cmake ${${libName}_SOURCE_DIR}/CMakeLists.txt COPYONLY)
        add_subdirectory(${${libName}_SOURCE_DIR})
        message(STATUS "${libName}: Successfully extracted sources for static library from GitHub")
    endif()
endif()
