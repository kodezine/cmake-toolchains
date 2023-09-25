if (${PROJECT_NAME} STREQUAL cmsis)

else ()
    cmake_minimum_required(VERSION 3.27)

    project(cmsis
        VERSION ${GITHUB_BRANCH_CMSIS}
        LANGUAGES C
        DESCRIPTION "Header only library for CMSIS"
    )
endif ()

# Main target ------------------------------------------------------------------
add_library(${PROJECT_NAME} INTERFACE)
add_library(${PROJECT_NAME}::framework ALIAS ${PROJECT_NAME})

# Includes ---------------------------------------------------------------------
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

# set public headers as a globbed function
file(GLOB ${PROJECT_NAME}_PUBLIC_HEADERS ${CMAKE_CURRENT_SOURCE_DIR}/CMSIS/Core/Include/*.h)

target_include_directories(${PROJECT_NAME}
    INTERFACE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/CMSIS/Core/Include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}>
)

set_target_properties(${PROJECT_NAME}
    PROPERTIES
        C_STANDARD          11
        C_STANDARD_REQUIRED ON
        C_EXTENSIONS        OFF
        PUBLIC_HEADER       "${${PROJECT_NAME}_PUBLIC_HEADERS}"
        EXPORT_NAME         framework
)

target_compile_options(${PROJECT_NAME}
    INTERFACE
        $<$<C_COMPILER_ID:Clang>:-Wcast-align
                                 -Wcast-qual
                                 -Wconversion
                                 -Wexit-time-destructors
                                 -Wglobal-constructors
                                 #-Wmissing-noreturn
                                 -Wmissing-prototypes
                                 -Wno-missing-braces
                                 -Wold-style-cast
                                 -Wshadow
                                 -Wweak-vtables
                                 #-Werror
                                 -Wall>
        $<$<C_COMPILER_ID:GNU>:-Waddress
                               -Waggregate-return
                               -Wformat-nonliteral
                               -Wformat-security
                               -Wformat
                               -Winit-self
                               -Wmissing-declarations
                               -Wmissing-include-dirs
                               -Wno-multichar
                               -Wno-parentheses
                               -Wno-type-limits
                               -Wno-unused-parameter
                               -Wunreachable-code
                               -Wwrite-strings
                               -Wpointer-arith
                               #-Werror
                               -Wall>
       $<$<C_COMPILER_ID:MSVC>:/Wall>
)

write_basic_package_version_file(${PROJECT_NAME}ConfigVersion.cmake
    VERSION       ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion
)

## Target installation
install(TARGETS   ${PROJECT_NAME}
    EXPORT        ${PROJECT_NAME}Targets
    ARCHIVE       DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY       DESTINATION ${CMAKE_INSTALL_LIBDIR}
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
