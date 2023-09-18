include(CMakePrintHelpers)
# this is for generating a target based include
string(TOUPPER ${CORTEX_TYPE} CORTEX_TYPE_UPPERCASE)
configure_file(${CMAKE_CURRENT_LIST_DIR}/targetbasedincludes.txt ${CMAKE_CURRENT_LIST_DIR}/targetbasedincludes.h @ONLY NEWLINE_STYLE UNIX)
# Function to setup project executable
function(setUnityTestProjectProperties project_name test_dir)

    set(UNITY_TEST_RUNNER_PATH ${CMAKE_CURRENT_BINARY_DIR}/runner)
    file(MAKE_DIRECTORY ${UNITY_TEST_RUNNER_PATH})
    execute_process(
        COMMAND ruby ${CMOCK_SCRIPT_PATH}/create_runner.rb ${test_dir}/target/${project_name}.c ${UNITY_TEST_RUNNER_PATH}/${project_name}_runner.c
    )
    set(TEST_INCLUDE_DIR "${test_dir}")

    add_executable(${project_name})

    target_sources(${project_name}
        PUBLIC
            ${TEST_INCLUDE_DIR}/target/${project_name}.c
            ${UNITY_TEST_RUNNER_PATH}/${project_name}_runner.c
            ${TEST_MOCK_SOURCES}
            ${TEST_SOURCES}
        PRIVATE
            ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/vectors.c
    )
    target_compile_definitions(${project_name}
        PUBLIC
            UNITY_MAKE_STATIC_GLOBAL    # Used by the compiler_attributes to expose static functions
            TESTING                     # Used by many older AO for conditional code injection/removal
    )

    target_include_directories(${project_name}
        PUBLIC
            $ENV{MOCK_OUT}

        PRIVATE
            ${TEST_MOCK_INCLUDES}
            ${TEST_INCLUDE_DIR}
            ${TEST_INCLUDE_DIR}/..
            ${OTHER_INCLUDE_DIR}
            ${CMAKE_CURRENT_FUNCTION_LIST_DIR}
    )

    target_link_libraries(${project_name}
        PUBLIC
            cmock
            cubemx
            m #math library
    )

    setTargetCompileOptions(project_name)
    setTargetLinkOptions(project_name)

    # Register the test bin as a ctest executable test
    add_test(NAME ctest_${project_name}
        COMMAND ${project_name}.elf
    )

endfunction()