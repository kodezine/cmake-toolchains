include(CMakePrintHelpers)
include(FetchContent)

set(GITHUB_BRANCH_CANOPENNODESTM32  "HEAD")
cmake_print_variables(GITHUB_BRANCH_CANOPENNODESTM32)

FetchContent_Declare(
    canopennode-stm32                             # Recommendation: Stick close to the original name.
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
    GIT_REPOSITORY https://github.com/CANopenNode/CanOpenSTM32.git
    GIT_TAG ${GITHUB_BRANCH_CANOPENNODESTM32}
)

FetchContent_GetProperties(canopennode-stm32)

if(NOT canopennode-stm32_POPULATED)
    FetchContent_Populate(canopennode-stm32)
endif()

if(EXISTS ${STM32CUBEMX_HAL_PATH})
    set(libName canopennode-stm32)
    message(STATUS "Building ${libName} with STMCubeMX HAL (libhal.a) at ${STMCUBEMX_HAL_PATH}")
    add_library(${libName} STATIC)

    target_sources(${libName}
        PRIVATE
        ${canopennode-stm32_SOURCE_DIR}/CANopenNode/301/CO_Emergency.c
        ${canopennode-stm32_SOURCE_DIR}/CANopenNode/301/CO_fifo.c
        ${canopennode-stm32_SOURCE_DIR}/CANopenNode/301/CO_HBconsumer.c
        ${canopennode-stm32_SOURCE_DIR}/CANopenNode/301/CO_NMT_Heartbeat.c
        ${canopennode-stm32_SOURCE_DIR}/CANopenNode/301/CO_ODinterface.c
        ${canopennode-stm32_SOURCE_DIR}/CANopenNode/301/CO_PDO.c
        ${canopennode-stm32_SOURCE_DIR}/CANopenNode/301/CO_SDOclient.c
        ${canopennode-stm32_SOURCE_DIR}/CANopenNode/301/CO_SDOserver.c
        ${canopennode-stm32_SOURCE_DIR}/CANopenNode/301/CO_SYNC.c
        ${canopennode-stm32_SOURCE_DIR}/CANopenNode/301/CO_TIME.c
        ${canopennode-stm32_SOURCE_DIR}/CANopenNode/301/crc16-ccitt.c

        ${canopennode-stm32_SOURCE_DIR}/CANopenNode/303/CO_LEDs.c

        ${canopennode-stm32_SOURCE_DIR}/CANopenNode/304/CO_GFC.c
        ${canopennode-stm32_SOURCE_DIR}/CANopenNode/304/CO_SRDO.c

        ${canopennode-stm32_SOURCE_DIR}/CANopenNode/305/CO_LSSmaster.c
        ${canopennode-stm32_SOURCE_DIR}/CANopenNode/305/CO_LSSslave.c

        ${canopennode-stm32_SOURCE_DIR}/CANopenNode/309/CO_gateway_ascii.c

        ${canopennode-stm32_SOURCE_DIR}/CANopenNode/extra/CO_trace.c

        ${canopennode-stm32_SOURCE_DIR}/CANopenNode/storage/CO_storage.c
        ${canopennode-stm32_SOURCE_DIR}/CANopenNode/storage/CO_storageEeprom.c

        ${canopennode-stm32_SOURCE_DIR}/CANopenNode/CANopen.c

        ${canopennode-stm32_SOURCE_DIR}/CANopenNode_STM32/CO_app_STM32.c
        ${canopennode-stm32_SOURCE_DIR}/CANopenNode_STM32/CO_driver_STM32.c
        ${canopennode-stm32_SOURCE_DIR}/CANopenNode_STM32/CO_storageBlank.c
    )

    target_include_directories(${libName}
        PUBLIC
        ${canopennode-stm32_SOURCE_DIR}/CANopenNode/301
        ${canopennode-stm32_SOURCE_DIR}/CANopenNode/303
        ${canopennode-stm32_SOURCE_DIR}/CANopenNode/304
        ${canopennode-stm32_SOURCE_DIR}/CANopenNode/305
        ${canopennode-stm32_SOURCE_DIR}/CANopenNode/309
        ${canopennode-stm32_SOURCE_DIR}/CANopenNode/extra
        ${canopennode-stm32_SOURCE_DIR}/CANopenNode/storage
        ${canopennode-stm32_SOURCE_DIR}/CANopenNode
        ${canopennode-stm32_SOURCE_DIR}/CANopenNode_STM32
    )

    target_link_libraries(${libName}
        hal
    )
    setTargetCompileOptions(libName)
else()
    message(FATAL_ERROR "CAN-not work without a STM32CubeMx based HAL layer library, quiting with pain.")
endif()

if(EXISTS ${CANOPEN_OBJECT_DICTIONARY_PATH})
    set(libName canopennode-od)
    message(STATUS "Building ${libName} with find OD.c/.h at ${CANOPEN_OBJECT_DICTIONARY_PATH}")
    add_library(${libName} STATIC)

    target_sources(${libName}
        PRIVATE
        ${canopennode-stm32_SOURCE_DIR}/CANopenNode_STM32/OD.c
    )

    target_include_directories(${libName}
        PUBLIC
        ${canopennode-stm32_SOURCE_DIR}/CANopenNode
        ${canopennode-stm32_SOURCE_DIR}/CANopenNode_STM32
    )

    target_link_libraries(${libName}
        hal
    )
    setTargetCompileOptions(libName)
else()
    message(FATAL_ERROR "CAN-not work without a object dictionary, quiting with pain.")
endif()