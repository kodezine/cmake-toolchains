include(FetchContent)

# The options to build the Fixtures and Memory for Unity are enabled here.
set(UNITY_EXTENSION_FIXTURE ON CACHE BOOL "Build unity with fixture")
set(UNITY_EXTENSION_MEMORY  ON CACHE BOOL "Build unity with memory")

set(GITHUB_BRANCH_UNITY "2.5.2")
set(GITHUB_BRANCH_UNITY_MD5 "41e6422c3a54a395abcae531293e254c")

cmake_print_variables(GITHUB_BRANCH_UNITY)

FetchContent_Declare(
    unity # Recommendation: Stick close to the original name.
    DOWNLOAD_EXTRACT_TIMESTAMP true
    URL https://github.com/ThrowTheSwitch/Unity/archive/refs/tags/v${GITHUB_BRANCH_UNITY}.tar.gz
    URL_HASH MD5=${GITHUB_BRANCH_UNITY_MD5}
#    GIT_REPOSITORY https://github.com/ThrowTheSwitch/Unity.git
#    GIT_TAG v2.5.2
)

FetchContent_GetProperties(unity)

if(NOT unity_POPULATED)
    FetchContent_Populate(unity)
    enable_testing()
    add_definitions(-DUNITY_INCLUDE_CONFIG_H)
    configure_file(${CMAKE_CURRENT_LIST_DIR}/target/unity_segger_rtt.txt ${unity_SOURCE_DIR}/src/unity_config.h COPYONLY)
    # Library libcomock.a is in the /build/_deps/cmock-build directory
    add_subdirectory(${unity_SOURCE_DIR} ${unity_BINARY_DIR})
    target_link_libraries(unity
        PUBLIC                  # The use of SEGGER RTT has to be public, else header is not found
            segger_rtt
    )
endif()

# establish the unity framework
set(ENV{UNITY_DIR} ${unity_SOURCE_DIR})
