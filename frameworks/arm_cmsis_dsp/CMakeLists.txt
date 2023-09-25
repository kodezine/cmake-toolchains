cmake_minimum_required (VERSION 3.22)

project(
    cmsis_dsp
    VERSION ${GITHUB_BRANCH_CMSIS_DSP}
    LANGUAGES C
    DESCRIPTION "CMSIS DSP made from scratch"
)

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

include(helper/BasicMathFunctions.cmake)
include(helper/ComplexMathFunctions.cmake)
include(helper/QuaternionMathFunctions.cmake)

set(CMSIS_DSP_Source_ControllerFunctions_PATH       ${cmsis_dsp_SOURCE_DIR}/Source/ControllerFunctions)
set(CMSIS_DSP_Source_FastMathFunctions_PATH         ${cmsis_dsp_SOURCE_DIR}/Source/FastMathFunctions)
set(CMSIS_DSP_Source_FilteringFunctions_PATH        ${cmsis_dsp_SOURCE_DIR}/Source/FilteringFunctions)
set(CMSIS_DSP_Source_MatrixFunctions_PATH           ${cmsis_dsp_SOURCE_DIR}/Source/MatrixFunctions)
set(CMSIS_DSP_Source_StatisticsFunctions_PATH       ${cmsis_dsp_SOURCE_DIR}/Source/StatisticsFunctions)
set(CMSIS_DSP_Source_SupportFunctions_PATH          ${cmsis_dsp_SOURCE_DIR}/Source/SupportFunctions)
set(CMSIS_DSP_Source_TransformFunctions_PATH        ${cmsis_dsp_SOURCE_DIR}/Source/TransformFunctions)
set(CMSIS_DSP_Source_CommonTables_PATH              ${cmsis_dsp_SOURCE_DIR}/Source/CommonTables)
set(CMSIS_DSP_Source_SVMFunctions_PATH              ${cmsis_dsp_SOURCE_DIR}/Source/SVMFunctions)
set(CMSIS_DSP_Source_BayesFunctions_PATH            ${cmsis_dsp_SOURCE_DIR}/Source/BayesFunctions)
set(CMSIS_DSP_Source_DistanceFunctions_PATH         ${cmsis_dsp_SOURCE_DIR}/Source/DistanceFunctions)
set(CMSIS_DSP_Source_InterpolationFunctions_PATH    ${cmsis_dsp_SOURCE_DIR}/Source/InterpolationFunctions)
set(CMSIS_DSP_Source_WindowFunctions_PATH           ${cmsis_dsp_SOURCE_DIR}/Source/WindowFunctions)


# set public headers as a globbed function
file(GLOB_RECURSE ${PROJECT_NAME}_PUBLIC_HEADERS ${cmsis_dsp_SOURCE_DIR}/Include/*.h)

target_sources(${PROJECT_NAME}
    PRIVATE
    ${BasicMathFunctions_SOURCES}
    ${ComplexMathFunctions_SOURCES}
    ${QuaternionMathFunctions_SOURCES}
)

target_include_directories(${PROJECT_NAME}

    PRIVATE
        $<BUILD_INTERFACE:${cmsis_dsp_SOURCE_DIR}/Include/dsp>
    PUBLIC
        $<BUILD_INTERFACE:${cmsis_dsp_SOURCE_DIR}/Include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}>
)

target_link_libraries(${PROJECT_NAME}
    INTERFACE
        cmsis
)

include(${cmsis_dsp_SOURCE_DIR}/Source/configDsp.cmake)

configDsp(${PROJECT_NAME})

write_basic_package_version_file(${PROJECT_NAME}ConfigVersion.cmake
    VERSION       ${GITHUB_BRANCH_CMSIS_DSP}
    COMPATIBILITY SameMajorVersion
)
set_target_properties(${PROJECT_NAME}
    PROPERTIES
        PUBLIC_HEADER "${${PROJECT_NAME}_PUBLIC_HEADERS}"
)

## Target installation
install(TARGETS   ${PROJECT_NAME}
    EXPORT        ${PROJECT_NAME}Targets
    ARCHIVE       DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY       DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME       DESTINATION ${CMAKE_INSTALL_BINDIR}
    PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}
    COMPONENT     library
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

