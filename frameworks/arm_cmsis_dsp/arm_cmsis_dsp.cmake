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
    # BANSHI specific CMSIS customization, helps to limit the tables to be imported to the flash memory
#    set(BASICMATH "ON"        CACHE BOOL "CMSIS-DSP basic math functions")
#    set(COMPLEXMATH "OFF"     CACHE BOOL "CMSIS-DSP complex math functions")
#    set(CONTROLLER "OFF"      CACHE BOOL "CMSIS-DSP controller functions")
#    set(FASTMATH "ON"         CACHE BOOL "CMSIS-DSP fast math functions")
#    set(FILTERING "OFF"       CACHE BOOL "CMSIS-DSP filtering functions")
#    set(MATRIX "ON"           CACHE BOOL "CMSIS-DSP matrices functions")
#    set(STATISTICS "OFF"      CACHE BOOL "CMSIS-DSP statistics functions")
#    set(SUPPORT "ON"          CACHE BOOL "CMSIS-DSP support functions")
#    set(TRANSFORM "OFF"       CACHE BOOL "CMSIS-DSP transformation functions")
#    set(SVM "OFF"             CACHE BOOL "CMSIS-DSP SVM functions")
#    set(BAYES "OFF"           CACHE BOOL "CMSIS-DSP Bayes functions")
#    set(DISTANCE "OFF"        CACHE BOOL "CMSIS-DSP distance functions")
#    set(INTERPOLATION "OFF"   CACHE BOOL "CMSIS-DSP interpolation functions")
#    set(QUATERNIONMATH "OFF"  CACHE BOOL "CMSIS-DSP qaterionmath functions")
#    set(CONFIGTABLE "ON"      CACHE BOOL "CMSIS-DSP configtable functions")
#    set(ARM_SIN_F32 "ON"      CACHE BOOL "CMSIS-DSP arm-sin floating 32 bit tables and functions")
#    set(ARM_COS_F32 "ON"      CACHE BOOL "CMSIS-DSP arm-cos floating 32 bit tables and functions")
