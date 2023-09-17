include(FetchContent)

# The options to build the Fixtures and Memory for Unity are enabled here.
set(UNITY_EXTENSION_FIXTURE ON CACHE BOOL "Build unity with fixture")
set(UNITY_EXTENSION_MEMORY  ON CACHE BOOL "Build unity with memory")


FetchContent_Declare(
    unity # Recommendation: Stick close to the original name.
    DOWNLOAD_EXTRACT_TIMESTAMP true
    URL https://github.com/ThrowTheSwitch/Unity/archive/refs/tags/v2.5.2.tar.gz
    URL_HASH MD5=41e6422c3a54a395abcae531293e254c # v2.5.2
#    GIT_REPOSITORY https://github.com/ThrowTheSwitch/Unity.git
#    GIT_TAG v2.5.2
)

FetchContent_GetProperties(unity)

if(NOT unity_POPULATED)
    FetchContent_Populate(unity)
    # Library libcomock.a is in the /build/_deps/cmock-build directory
    add_subdirectory(${unity_SOURCE_DIR} ${unity_BINARY_DIR})
endif()
