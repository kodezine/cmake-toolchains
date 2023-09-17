include(FetchContent)

FetchContent_Declare(
    cmock  # Recommendation: Stick close to the original name.
    DOWNLOAD_EXTRACT_TIMESTAMP true
    URL https://github.com/ThrowTheSwitch/CMock/archive/refs/tags/v2.5.3.tar.gz
    URL_HASH MD5=fe3d01fdd6c267ffef38164926c7bc3d # v2.5.3
    #GIT_REPOSITORY https://github.com/ThrowTheSwitch/CMock.git
    #GIT_TAG        v2.5.3
)

FetchContent_GetProperties(cmock)

if(NOT cmock_POPULATED)
    FetchContent_Populate(cmock)

    configure_file(${CMAKE_CURRENT_LIST_DIR}/target/cortex-m.cmake ${cmock_SOURCE_DIR}/CMakeLists.txt)
    # Library libcomock.a is in the /build/_deps/cmock-build directory
    add_subdirectory(${cmock_SOURCE_DIR} ${cmock_BINARY_DIR})
endif()
