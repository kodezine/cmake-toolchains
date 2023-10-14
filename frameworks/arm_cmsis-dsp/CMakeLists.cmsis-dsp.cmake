if (${PROJECT_NAME} STREQUAL cmsis-dsp)

else ()
    cmake_minimum_required(VERSION 3.27)
    project(
        cmsis-dsp
        VERSION ${GITHUB_BRANCH_cmsis-dsp}
        LANGUAGES C
        DESCRIPTION "CMSIS DSP made from scratch"
    )
endif ()

cmake_print_variables(cmsis-v5_CORE_INCLUDE_PATH cmsis-v5_DEVICE_INCLUDE_PATH)

option(NEON "Neon acceleration" OFF)
option(NEONEXPERIMENTAL "Neon experimental acceleration" OFF)
option(HELIUMEXPERIMENTAL "Helium experimental acceleration" OFF)
option(LOOPUNROLL "Loop unrolling" ON)
option(ROUNDING "Rounding" OFF)
option(MATRIXCHECK "Matrix Checks" OFF)
option(HELIUM "Helium acceleration (MVEF and MVEI supported)" OFF)
option(MVEF "MVEF intrinsics supported" OFF)
option(MVEI "MVEI intrinsics supported" OFF)
option(MVEFLOAT16 "Float16 MVE intrinsics supported" OFF)
option(DISABLEFLOAT16 "Disable building float16 kernels" OFF)
option(HOST "Build for host" OFF)
option(AUTOVECTORIZE "Prefer autovectorizable code to one using C intrinsics" OFF)
option(LAXVECTORCONVERSIONS "Lax vector conversions" ON)

###########################
#
# CMSIS DSP
#
###########################

# Includes ---------------------------------------------------------------------
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

add_library(${PROJECT_NAME} STATIC)
add_library(${PROJECT_NAME}::framework ALIAS ${PROJECT_NAME})

include(${cmake-toolchains_SOURCE_DIR}/frameworks/arm_${PROJECT_NAME}/helper/BasicMathFunctions.cmake)
include(${cmake-toolchains_SOURCE_DIR}/frameworks/arm_${PROJECT_NAME}/helper/BayesFunctions.cmake)
include(${cmake-toolchains_SOURCE_DIR}/frameworks/arm_${PROJECT_NAME}/helper/CommonTables.cmake)
include(${cmake-toolchains_SOURCE_DIR}/frameworks/arm_${PROJECT_NAME}/helper/ComplexMathFunctions.cmake)
include(${cmake-toolchains_SOURCE_DIR}/frameworks/arm_${PROJECT_NAME}/helper/ControllerFunctions.cmake)
include(${cmake-toolchains_SOURCE_DIR}/frameworks/arm_${PROJECT_NAME}/helper/DistanceFunctions.cmake)
include(${cmake-toolchains_SOURCE_DIR}/frameworks/arm_${PROJECT_NAME}/helper/FastMathFunctions.cmake)
include(${cmake-toolchains_SOURCE_DIR}/frameworks/arm_${PROJECT_NAME}/helper/FilteringFunctions.cmake)
include(${cmake-toolchains_SOURCE_DIR}/frameworks/arm_${PROJECT_NAME}/helper/InterpolationFunctions.cmake)
include(${cmake-toolchains_SOURCE_DIR}/frameworks/arm_${PROJECT_NAME}/helper/MatrixFunctions.cmake)
include(${cmake-toolchains_SOURCE_DIR}/frameworks/arm_${PROJECT_NAME}/helper/QuaternionMathFunctions.cmake)
include(${cmake-toolchains_SOURCE_DIR}/frameworks/arm_${PROJECT_NAME}/helper/StatisticsFunctions.cmake)
include(${cmake-toolchains_SOURCE_DIR}/frameworks/arm_${PROJECT_NAME}/helper/SupportFunctions.cmake)
include(${cmake-toolchains_SOURCE_DIR}/frameworks/arm_${PROJECT_NAME}/helper/SVMFunctions.cmake)
include(${cmake-toolchains_SOURCE_DIR}/frameworks/arm_${PROJECT_NAME}/helper/TransformFunctions.cmake)
include(${cmake-toolchains_SOURCE_DIR}/frameworks/arm_${PROJECT_NAME}/helper/WindowFunctions.cmake)

# set public headers as a globbed function
file(GLOB_RECURSE ${PROJECT_NAME}_PUBLIC_HEADERS ${${PROJECT_NAME}_SOURCE_DIR}/Include/*.h)

target_sources(${PROJECT_NAME}
    PRIVATE
    ${BasicMathFunctions_SOURCES}
    ${BayesFunctions_SOURCES}
    ${CommonTables_SOURCES}
    ${ControllerFunctions_SOURCES}
    ${ComplexMathFunctions_SOURCES}
    ${DistanceFunctions_SOURCES}
    ${FastMathFunctions_SOURCES}
    ${FilteringFunctions_SOURCES}
    ${InterpolationFunctions_SOURCES}
    ${MatrixFunctions_SOURCES}
    ${QuaternionMathFunctions_SOURCES}
    ${StatisticsFunctions_SOURCES}
    ${SupportFunctions_SOURCES}
    ${SVMFunctions_SOURCES}
    ${TransformFunctions_SOURCES}
    ${WindowFunctions_SOURCES}
)

# Target sources for importing headers for this static library
target_sources(${PROJECT_NAME}
    PUBLIC
        FILE_SET ${PROJECT_NAME}_Headers
        TYPE HEADERS
        BASE_DIRS ${${PROJECT_NAME}_SOURCE_DIR}/Include
        FILES
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/arm_common_tables_f16.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/arm_common_tables.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/arm_const_structs_f16.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/arm_const_structs.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/arm_helium_utils.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/arm_math_f16.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/arm_math_memory.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/arm_math_types_f16.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/arm_math_types.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/arm_math.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/arm_mve_tables_f16.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/arm_mve_tables.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/arm_vec_math_f16.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/arm_vec_math.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/basic_math_functions.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/basic_math_functions_f16.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/bayes_functions.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/bayes_functions_f16.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/complex_math_functions.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/complex_math_functions_f16.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/controller_functions.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/controller_functions_f16.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/debug.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/distance_functions.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/distance_functions_f16.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/fast_math_functions.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/fast_math_functions_f16.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/filtering_functions.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/filtering_functions_f16.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/interpolation_functions.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/interpolation_functions_f16.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/matrix_functions.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/matrix_functions_f16.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/matrix_utils.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/none.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/quaternion_math_functions.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/statistics_functions.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/statistics_functions_f16.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/support_functions.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/support_functions_f16.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/svm_defines.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/svm_functions.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/svm_functions_f16.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/transform_functions.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/transform_functions_f16.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/utils.h
            ${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp/window_functions.h
)

target_include_directories(${PROJECT_NAME}

    PRIVATE
        ${cmsis-v5_CORE_INCLUDE_PATH}
        ${cmsis-v5_DEVICE_INCLUDE_PATH}
        $<BUILD_INTERFACE:${${PROJECT_NAME}_SOURCE_DIR}/PrivateInclude>
    PUBLIC
        $<BUILD_INTERFACE:${${PROJECT_NAME}_SOURCE_DIR}/Include>
        $<BUILD_INTERFACE:${${PROJECT_NAME}_SOURCE_DIR}/Include/dsp>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}>
)

target_link_libraries(${PROJECT_NAME}
    INTERFACE
        cmsis-v5
)

include(${${PROJECT_NAME}_SOURCE_DIR}/Source/configDsp.cmake)

configDsp(${PROJECT_NAME})

write_basic_package_version_file(${PROJECT_NAME}ConfigVersion.cmake
    VERSION       ${GITHUB_BRANCH_CMSIS_DSP}
    COMPATIBILITY SameMajorVersion
)

## Target installation
install(TARGETS     ${PROJECT_NAME}
    EXPORT          ${PROJECT_NAME}Targets
    FILE_SET        ${PROJECT_NAME}_Headers
    ARCHIVE         DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY         DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME         DESTINATION ${CMAKE_INSTALL_BINDIR}
    PUBLIC_HEADER   DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}
    COMPONENT       library
)

## Target's cmake files: targets export
install(EXPORT  ${PROJECT_NAME}Targets
    NAMESPACE   ${PROJECT_NAME}::
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

## Target's cmake files: config and version config for find_package()
install(FILES   ${PROJECT_NAME}Config.cmake
            ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

