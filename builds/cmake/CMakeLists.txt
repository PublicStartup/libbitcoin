###############################################################################
#  Copyright (c) 2014-2018 libbitcoin developers (see COPYING).
#
#         GENERATED SOURCE CODE, DO NOT EDIT EXCEPT EXPERIMENTALLY
#
###############################################################################

# libbitcoin project configuration.
#------------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

project(libbitcoin LANGUAGES C CXX)

enable_testing()

list( APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/modules" )
include(CheckIncludeFiles)
include(CheckSymbolExists)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

if (MSVC)
  set( CANONICAL_LIB_NAME libbitcoin )
else ()
  set( CANONICAL_LIB_NAME bitcoin )
  find_package( PkgConfig REQUIRED )

  set( prefix "${CMAKE_PREFIX_PATH}" )
  set( exec_prefix "\${prefix}" )
  set( libdir "\${exec_prefix}/lib" )
  set( includedir "\${exec_prefix}/include" )

  set( PACKAGE_VERSION "4.0.0" )
  set( VERSION "${PACKAGE_VERSION}" )
endif ()

set( CMAKE_CXX_STANDARD 11 )
set( CMAKE_CXX_STANDARD_REQUIRED ON )

# Add compiler options
#------------------------------------------------------------------------------
# Warn on all stuff.
add_compile_options( "-Wall" )

# Warn on extra stuff.
add_compile_options( "-Wextra" )

# Be really annoying.
add_compile_options( "-Wpedantic" )

# Disallow warning on style order of declarations.
add_compile_options( "-Wno-reorder" )

# Suppress warning for incomplete field initialization.
add_compile_options( "-Wno-missing-field-initializers" )

# Conform to style.
add_compile_options( "-Wno-missing-braces" )

# Ignore comments within comments or commenting of backslash extended lines.
add_compile_options( "-Wno-comment" )

# Allow use of C99 'long long' type.
add_compile_options( "-Wno-long-long" )

# Conflict in stdlib under clang.
if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    add_compile_options( "-Wno-mismatched-tags" )
endif()

# Limit delays and warnings.
if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    add_compile_options( "-fno-var-tracking-assignments" )
endif()

# Implement -Dpkgconfigdir and output ${pkgconfigdir}.
#------------------------------------------------------------------------------
set( pkgconfigdir "${libdir}/pkgconfig" CACHE PATH "Path to pkgconfig directory." )

# Implement -Dwith-tests and declare with-tests.
#------------------------------------------------------------------------------
set( with-tests "yes" CACHE BOOL "Compile with unit tests." )

# Implement -Dwith-examples and declare with-examples.
#------------------------------------------------------------------------------
set( with-examples "yes" CACHE BOOL "Compile with examples." )

# Implement -Dwith-icu and define BOOST_HAS_ICU and output ${icu}.
#------------------------------------------------------------------------------
set( with-icu "no" CACHE BOOL "Compile with International Components for Unicode." )

if (with-icu)
    add_definitions( -DBOOST_HAS_ICU )
endif()

if (with-icu)
    set( icu "-DWITH_ICU" )
endif()

# Implement -Dwith-png and output ${png}.
#------------------------------------------------------------------------------
set( with-png "no" CACHE BOOL "Compile with Libpng support." )

if (with-png)
    set( png "-DWITH_PNG" )
endif()

# Implement -Dwith-qrencode and output ${qrencode}.
#------------------------------------------------------------------------------
set( with-qrencode "no" CACHE BOOL "Compile with QREncode." )

if (with-qrencode)
    set( qrencode "-DWITH_QRENCODE" )
endif()

# Implement -Denable-ndebug and define NDEBUG.
#------------------------------------------------------------------------------
set( enable-ndebug "yes" CACHE BOOL "Compile without debug assertions." )

if (enable-ndebug)
    add_definitions( -DNDEBUG )
endif()

# Inherit -Denable-shared and define BOOST_ALL_DYN_LINK.
#------------------------------------------------------------------------------
if (BUILD_SHARED_LIBS)
    add_definitions( -DBOOST_ALL_DYN_LINK )
endif()

# Find boost
#------------------------------------------------------------------------------
find_package( Boost 1.62.0 REQUIRED COMPONENTS
    atomic
    chrono
    date_time
    filesystem
    iostreams
    locale
    log_setup
    log
    program_options
    regex
    system
    thread
    unit_test_framework )

set( boost_atomic_LIBS "-lboost_atomic" )
set( boost_chrono_LIBS "-lboost_chrono" )
set( boost_date_time_LIBS "-lboost_date_time" )
set( boost_filesystem_LIBS "-lboost_filesystem" )
set( boost_iostreams_LIBS "-lboost_iostreams" )
set( boost_locale_LIBS "-lboost_locale" )
set( boost_log_setup_LIBS "-lboost_log_setup" )
set( boost_log_LIBS "-lboost_log" )
set( boost_program_options_LIBS "-lboost_program_options" )
set( boost_regex_LIBS "-lboost_regex" )
set( boost_system_LIBS "-lboost_system" )
set( boost_thread_LIBS "-lboost_thread" )
set( boost_unit_test_framework_LIBS "-lboost_unit_test_framework" )

if (enable-ndebug)
    set( Boost_LIBRARY_DIR "${Boost_LIBRARY_DIR_DEBUG}" )
else ()
    set( Boost_LIBRARY_DIR "${Boost_LIBRARY_DIR_RELEASE}" )
endif()

set( boost_CPPFLAGS "-I${Boost_INCLUDE_DIR}" )
set( boost_LDFLAGS "-L${Boost_LIBRARY_DIR}" )

set( CMAKE_THREAD_PREFER_PTHREAD ON )
set( THREADS_PREFER_PTHREAD_FLAG ON )

# Find threads
#------------------------------------------------------------------------------
if (NOT ANDROID)
    find_package( Threads REQUIRED )
endif()

if ( Threads_FOUND AND NOT ANDROID )
    # TODO: find proper detection - documentation on FindThreads appears incorrect.
    set( pthread_CPPFLAGS "" )
    set( pthread_LIBRARIES "-lpthread" )
    set( pthread_LIBS "-lpthread" )
endif()

# Find rt
#------------------------------------------------------------------------------
if ((${CMAKE_SYSTEM_NAME} MATCHES "Linux") AND NOT ANDROID)
    find_package( Rt REQUIRED )
endif()

# Find icu-i18n
#------------------------------------------------------------------------------
if (with-icu)
    find_package( Icu-I18N 51.2 REQUIRED )
endif()

# Find dl
#------------------------------------------------------------------------------
if ((${CMAKE_SYSTEM_NAME} MATCHES "Linux"))
    find_package( Dl REQUIRED )
endif()

# Find png
#------------------------------------------------------------------------------
if (with-png)
    find_package( Png 1.6.29 REQUIRED )
endif()

# Find qrencode
#------------------------------------------------------------------------------
if (with-qrencode)
    find_package( Qrencode 3.4.4 REQUIRED )
endif()

# Find secp256k1
#------------------------------------------------------------------------------
find_package( Secp256K1 0.0.1 REQUIRED )

# Define project common includes directories
#------------------------------------------------------------------------------
if (BUILD_SHARED_LIBS)
    include_directories( SYSTEM
        ${Boost_INCLUDE_DIR}
        ${pthread_INCLUDE_DIRS}
        ${rt_INCLUDE_DIRS}
        ${icu_i18n_INCLUDE_DIRS}
        ${dl_INCLUDE_DIRS}
        ${png_INCLUDE_DIRS}
        ${qrencode_INCLUDE_DIRS}
        ${secp256k1_INCLUDE_DIRS} )
else()
    include_directories( SYSTEM
        ${Boost_INCLUDE_DIR}
        ${pthread_INCLUDE_DIRS}
        ${rt_INCLUDE_DIRS}
        ${icu_i18n_STATIC_INCLUDE_DIRS}
        ${dl_INCLUDE_DIRS}
        ${png_STATIC_INCLUDE_DIRS}
        ${qrencode_STATIC_INCLUDE_DIRS}
        ${secp256k1_STATIC_INCLUDE_DIRS} )
endif()

# Define project common library directories
#------------------------------------------------------------------------------
if (BUILD_SHARED_LIBS)
    link_directories( 
        ${Boost_LIBRARY_DIRS}
        ${pthread_LIBRARY_DIRS}
        ${rt_LIBRARY_DIRS}
        ${icu_i18n_LIBRARY_DIRS}
        ${dl_LIBRARY_DIRS}
        ${png_LIBRARY_DIRS}
        ${qrencode_LIBRARY_DIRS}
        ${secp256k1_LIBRARY_DIRS} )
else()
    link_directories( 
        ${Boost_LIBRARY_DIRS}
        ${pthread_LIBRARY_DIRS}
        ${rt_LIBRARY_DIRS}
        ${icu_i18n_STATIC_LIBRARY_DIRS}
        ${dl_LIBRARY_DIRS}
        ${png_STATIC_LIBRARY_DIRS}
        ${qrencode_STATIC_LIBRARY_DIRS}
        ${secp256k1_STATIC_LIBRARY_DIRS} )
endif()

# Define project common libraries/linker flags.
#------------------------------------------------------------------------------
if (BUILD_SHARED_LIBS)
    link_libraries( 
        "-fstack-protector"
        "-fstack-protector-all"
        ${Boost_CHRONO_LIBRARY}
        ${Boost_DATE_TIME_LIBRARY}
        ${Boost_FILESYSTEM_LIBRARY}
        ${Boost_IOSTREAMS_LIBRARY}
        ${Boost_LOCALE_LIBRARY}
        ${Boost_LOG_LIBRARY}
        ${Boost_PROGRAM_OPTIONS_LIBRARY}
        ${Boost_REGEX_LIBRARY}
        ${Boost_SYSTEM_LIBRARY}
        ${Boost_THREAD_LIBRARY}
        ${pthread_LIBRARIES}
        ${rt_LIBRARIES}
        ${icu_i18n_LIBRARIES}
        ${dl_LIBRARIES}
        ${png_LIBRARIES}
        ${qrencode_LIBRARIES}
        ${secp256k1_LIBRARIES} )
else()
    link_libraries( 
        "-fstack-protector"
        "-fstack-protector-all"
        ${Boost_CHRONO_LIBRARY}
        ${Boost_DATE_TIME_LIBRARY}
        ${Boost_FILESYSTEM_LIBRARY}
        ${Boost_IOSTREAMS_LIBRARY}
        ${Boost_LOCALE_LIBRARY}
        ${Boost_LOG_LIBRARY}
        ${Boost_PROGRAM_OPTIONS_LIBRARY}
        ${Boost_REGEX_LIBRARY}
        ${Boost_SYSTEM_LIBRARY}
        ${Boost_THREAD_LIBRARY}
        ${pthread_LIBRARIES}
        ${rt_LIBRARIES}
        ${icu_i18n_STATIC_LIBRARIES}
        ${dl_LIBRARIES}
        ${png_STATIC_LIBRARIES}
        ${qrencode_STATIC_LIBRARIES}
        ${secp256k1_STATIC_LIBRARIES} )
endif()

add_definitions( 
    ${icu}
    ${png}
    ${qrencode} )

# Define ${CANONICAL_LIB_NAME} project.
#------------------------------------------------------------------------------
add_library( ${CANONICAL_LIB_NAME}
    "../../src/error.cpp"
    "../../src/settings.cpp"
    "../../src/chain/block.cpp"
    "../../src/chain/chain_state.cpp"
    "../../src/chain/compact.cpp"
    "../../src/chain/header.cpp"
    "../../src/chain/input.cpp"
    "../../src/chain/output.cpp"
    "../../src/chain/output_point.cpp"
    "../../src/chain/payment_record.cpp"
    "../../src/chain/point.cpp"
    "../../src/chain/point_value.cpp"
    "../../src/chain/points_value.cpp"
    "../../src/chain/script.cpp"
    "../../src/chain/stealth_record.cpp"
    "../../src/chain/transaction.cpp"
    "../../src/chain/witness.cpp"
    "../../src/config/authority.cpp"
    "../../src/config/base16.cpp"
    "../../src/config/base2.cpp"
    "../../src/config/base58.cpp"
    "../../src/config/base64.cpp"
    "../../src/config/block.cpp"
    "../../src/config/checkpoint.cpp"
    "../../src/config/directory.cpp"
    "../../src/config/endpoint.cpp"
    "../../src/config/hash160.cpp"
    "../../src/config/hash256.cpp"
    "../../src/config/header.cpp"
    "../../src/config/input.cpp"
    "../../src/config/output.cpp"
    "../../src/config/parameter.cpp"
    "../../src/config/parser.cpp"
    "../../src/config/point.cpp"
    "../../src/config/printer.cpp"
    "../../src/config/script.cpp"
    "../../src/config/sodium.cpp"
    "../../src/config/transaction.cpp"
    "../../src/formats/base_10.cpp"
    "../../src/formats/base_16.cpp"
    "../../src/formats/base_32.cpp"
    "../../src/formats/base_58.cpp"
    "../../src/formats/base_64.cpp"
    "../../src/formats/base_85.cpp"
    "../../src/log/file_collector.cpp"
    "../../src/log/file_collector_repository.cpp"
    "../../src/log/file_counter_formatter.cpp"
    "../../src/log/sink.cpp"
    "../../src/log/statsd_sink.cpp"
    "../../src/log/udp_client_sink.cpp"
    "../../src/machine/interpreter.cpp"
    "../../src/machine/number.cpp"
    "../../src/machine/opcode.cpp"
    "../../src/machine/operation.cpp"
    "../../src/machine/program.cpp"
    "../../src/math/checksum.cpp"
    "../../src/math/crypto.cpp"
    "../../src/math/ec_point.cpp"
    "../../src/math/ec_scalar.cpp"
    "../../src/math/elliptic_curve.cpp"
    "../../src/math/hash.cpp"
    "../../src/math/ring_signature.cpp"
    "../../src/math/secp256k1_initializer.cpp"
    "../../src/math/secp256k1_initializer.hpp"
    "../../src/math/stealth.cpp"
    "../../src/math/external/aes256.c"
    "../../src/math/external/aes256.h"
    "../../src/math/external/crypto_scrypt.c"
    "../../src/math/external/crypto_scrypt.h"
    "../../src/math/external/hmac_sha256.c"
    "../../src/math/external/hmac_sha256.h"
    "../../src/math/external/hmac_sha512.c"
    "../../src/math/external/hmac_sha512.h"
    "../../src/math/external/lax_der_parsing.c"
    "../../src/math/external/lax_der_parsing.h"
    "../../src/math/external/pbkdf2_sha256.c"
    "../../src/math/external/pbkdf2_sha256.h"
    "../../src/math/external/pkcs5_pbkdf2.c"
    "../../src/math/external/pkcs5_pbkdf2.h"
    "../../src/math/external/ripemd160.c"
    "../../src/math/external/ripemd160.h"
    "../../src/math/external/sha1.c"
    "../../src/math/external/sha1.h"
    "../../src/math/external/sha256.c"
    "../../src/math/external/sha256.h"
    "../../src/math/external/sha512.c"
    "../../src/math/external/sha512.h"
    "../../src/math/external/zeroize.c"
    "../../src/math/external/zeroize.h"
    "../../src/message/address.cpp"
    "../../src/message/alert.cpp"
    "../../src/message/alert_payload.cpp"
    "../../src/message/block.cpp"
    "../../src/message/block_transactions.cpp"
    "../../src/message/compact_block.cpp"
    "../../src/message/fee_filter.cpp"
    "../../src/message/filter_add.cpp"
    "../../src/message/filter_clear.cpp"
    "../../src/message/filter_load.cpp"
    "../../src/message/get_address.cpp"
    "../../src/message/get_block_transactions.cpp"
    "../../src/message/get_blocks.cpp"
    "../../src/message/get_data.cpp"
    "../../src/message/get_headers.cpp"
    "../../src/message/header.cpp"
    "../../src/message/headers.cpp"
    "../../src/message/heading.cpp"
    "../../src/message/inventory.cpp"
    "../../src/message/inventory_vector.cpp"
    "../../src/message/memory_pool.cpp"
    "../../src/message/merkle_block.cpp"
    "../../src/message/messages.cpp"
    "../../src/message/network_address.cpp"
    "../../src/message/not_found.cpp"
    "../../src/message/ping.cpp"
    "../../src/message/pong.cpp"
    "../../src/message/prefilled_transaction.cpp"
    "../../src/message/reject.cpp"
    "../../src/message/send_compact.cpp"
    "../../src/message/send_headers.cpp"
    "../../src/message/transaction.cpp"
    "../../src/message/verack.cpp"
    "../../src/message/version.cpp"
    "../../src/unicode/console_streambuf.cpp"
    "../../src/unicode/ifstream.cpp"
    "../../src/unicode/ofstream.cpp"
    "../../src/unicode/unicode.cpp"
    "../../src/unicode/unicode_istream.cpp"
    "../../src/unicode/unicode_ostream.cpp"
    "../../src/unicode/unicode_streambuf.cpp"
    "../../src/utility/binary.cpp"
    "../../src/utility/conditional_lock.cpp"
    "../../src/utility/deadline.cpp"
    "../../src/utility/dispatcher.cpp"
    "../../src/utility/flush_lock.cpp"
    "../../src/utility/interprocess_lock.cpp"
    "../../src/utility/istream_reader.cpp"
    "../../src/utility/monitor.cpp"
    "../../src/utility/ostream_writer.cpp"
    "../../src/utility/png.cpp"
    "../../src/utility/prioritized_mutex.cpp"
    "../../src/utility/property_tree.cpp"
    "../../src/utility/pseudo_random.cpp"
    "../../src/utility/scope_lock.cpp"
    "../../src/utility/sequencer.cpp"
    "../../src/utility/sequential_lock.cpp"
    "../../src/utility/socket.cpp"
    "../../src/utility/string.cpp"
    "../../src/utility/thread.cpp"
    "../../src/utility/threadpool.cpp"
    "../../src/utility/work.cpp"
    "../../src/wallet/bitcoin_uri.cpp"
    "../../src/wallet/dictionary.cpp"
    "../../src/wallet/ec_private.cpp"
    "../../src/wallet/ec_public.cpp"
    "../../src/wallet/ek_private.cpp"
    "../../src/wallet/ek_public.cpp"
    "../../src/wallet/ek_token.cpp"
    "../../src/wallet/electrum.cpp"
    "../../src/wallet/electrum_dictionary.cpp"
    "../../src/wallet/encrypted_keys.cpp"
    "../../src/wallet/hd_private.cpp"
    "../../src/wallet/hd_public.cpp"
    "../../src/wallet/message.cpp"
    "../../src/wallet/mini_keys.cpp"
    "../../src/wallet/mnemonic.cpp"
    "../../src/wallet/payment_address.cpp"
    "../../src/wallet/qrcode.cpp"
    "../../src/wallet/select_outputs.cpp"
    "../../src/wallet/stealth_address.cpp"
    "../../src/wallet/stealth_receiver.cpp"
    "../../src/wallet/stealth_sender.cpp"
    "../../src/wallet/uri.cpp"
    "../../src/wallet/parse_encrypted_keys/parse_encrypted_key.hpp"
    "../../src/wallet/parse_encrypted_keys/parse_encrypted_key.ipp"
    "../../src/wallet/parse_encrypted_keys/parse_encrypted_prefix.hpp"
    "../../src/wallet/parse_encrypted_keys/parse_encrypted_prefix.ipp"
    "../../src/wallet/parse_encrypted_keys/parse_encrypted_private.cpp"
    "../../src/wallet/parse_encrypted_keys/parse_encrypted_private.hpp"
    "../../src/wallet/parse_encrypted_keys/parse_encrypted_public.cpp"
    "../../src/wallet/parse_encrypted_keys/parse_encrypted_public.hpp"
    "../../src/wallet/parse_encrypted_keys/parse_encrypted_token.cpp"
    "../../src/wallet/parse_encrypted_keys/parse_encrypted_token.hpp" )

# ${CANONICAL_LIB_NAME} project specific include directories.
#------------------------------------------------------------------------------
if (BUILD_SHARED_LIBS)
    target_include_directories( ${CANONICAL_LIB_NAME} PRIVATE
        "../../include"
        ${Boost_INCLUDE_DIR}
        ${pthread_INCLUDE_DIRS}
        ${rt_INCLUDE_DIRS}
        ${icu_i18n_INCLUDE_DIRS}
        ${dl_INCLUDE_DIRS}
        ${png_INCLUDE_DIRS}
        ${qrencode_INCLUDE_DIRS}
        ${secp256k1_INCLUDE_DIRS} )
else()
    target_include_directories( ${CANONICAL_LIB_NAME} PRIVATE
        "../../include"
        ${Boost_INCLUDE_DIR}
        ${pthread_INCLUDE_DIRS}
        ${rt_INCLUDE_DIRS}
        ${icu_i18n_STATIC_INCLUDE_DIRS}
        ${dl_INCLUDE_DIRS}
        ${png_STATIC_INCLUDE_DIRS}
        ${qrencode_STATIC_INCLUDE_DIRS}
        ${secp256k1_STATIC_INCLUDE_DIRS} )
endif()

target_include_directories( ${CANONICAL_LIB_NAME} PUBLIC
"../../include" )

# ${CANONICAL_LIB_NAME} project specific libraries/linker flags.
#------------------------------------------------------------------------------
if (BUILD_SHARED_LIBS)
    target_link_libraries( ${CANONICAL_LIB_NAME}
        ${Boost_CHRONO_LIBRARY}
        ${Boost_DATE_TIME_LIBRARY}
        ${Boost_FILESYSTEM_LIBRARY}
        ${Boost_IOSTREAMS_LIBRARY}
        ${Boost_LOCALE_LIBRARY}
        ${Boost_LOG_LIBRARY}
        ${Boost_PROGRAM_OPTIONS_LIBRARY}
        ${Boost_REGEX_LIBRARY}
        ${Boost_SYSTEM_LIBRARY}
        ${Boost_THREAD_LIBRARY}
        ${pthread_LIBRARIES}
        ${rt_LIBRARIES}
        ${icu_i18n_LIBRARIES}
        ${dl_LIBRARIES}
        ${png_LIBRARIES}
        ${qrencode_LIBRARIES}
        ${secp256k1_LIBRARIES} )
else()
    target_link_libraries( ${CANONICAL_LIB_NAME}
        ${Boost_CHRONO_LIBRARY}
        ${Boost_DATE_TIME_LIBRARY}
        ${Boost_FILESYSTEM_LIBRARY}
        ${Boost_IOSTREAMS_LIBRARY}
        ${Boost_LOCALE_LIBRARY}
        ${Boost_LOG_LIBRARY}
        ${Boost_PROGRAM_OPTIONS_LIBRARY}
        ${Boost_REGEX_LIBRARY}
        ${Boost_SYSTEM_LIBRARY}
        ${Boost_THREAD_LIBRARY}
        ${pthread_LIBRARIES}
        ${rt_LIBRARIES}
        ${icu_i18n_STATIC_LIBRARIES}
        ${dl_LIBRARIES}
        ${png_STATIC_LIBRARIES}
        ${qrencode_STATIC_LIBRARIES}
        ${secp256k1_STATIC_LIBRARIES} )
endif()

# Define libbitcoin-examples project.
#------------------------------------------------------------------------------
if (with-examples)
    add_executable( libbitcoin-examples
        "../../examples/main.cpp" )

#     libbitcoin-examples project specific include directories.
#------------------------------------------------------------------------------
    target_include_directories( libbitcoin-examples PRIVATE
        "../../include" )

#     libbitcoin-examples project specific libraries/linker flags.
#------------------------------------------------------------------------------
    target_link_libraries( libbitcoin-examples
        ${CANONICAL_LIB_NAME} )

endif()

# Define libbitcoin-test project.
#------------------------------------------------------------------------------
if (with-tests)
    add_executable( libbitcoin-test
        "../../test/.gitignore"
        "../../test/main.cpp"
        "../../test/settings.cpp"
        "../../test/chain/block.cpp"
        "../../test/chain/chain_state.cpp"
        "../../test/chain/compact.cpp"
        "../../test/chain/header.cpp"
        "../../test/chain/input.cpp"
        "../../test/chain/output.cpp"
        "../../test/chain/output_point.cpp"
        "../../test/chain/payment_record.cpp"
        "../../test/chain/point.cpp"
        "../../test/chain/point_value.cpp"
        "../../test/chain/points_value.cpp"
        "../../test/chain/satoshi_words.cpp"
        "../../test/chain/script.cpp"
        "../../test/chain/script.hpp"
        "../../test/chain/stealth_record.cpp"
        "../../test/chain/transaction.cpp"
        "../../test/config/authority.cpp"
        "../../test/config/base58.cpp"
        "../../test/config/block.cpp"
        "../../test/config/checkpoint.cpp"
        "../../test/config/endpoint.cpp"
        "../../test/config/hash256.cpp"
        "../../test/config/parameter.cpp"
        "../../test/config/printer.cpp"
        "../../test/formats/base_10.cpp"
        "../../test/formats/base_16.cpp"
        "../../test/formats/base_32.cpp"
        "../../test/formats/base_58.cpp"
        "../../test/formats/base_64.cpp"
        "../../test/formats/base_85.cpp"
        "../../test/machine/number.cpp"
        "../../test/machine/number.hpp"
        "../../test/machine/opcode.cpp"
        "../../test/machine/operation.cpp"
        "../../test/math/checksum.cpp"
        "../../test/math/ec_point.cpp"
        "../../test/math/ec_scalar.cpp"
        "../../test/math/elliptic_curve.cpp"
        "../../test/math/hash.cpp"
        "../../test/math/hash.hpp"
        "../../test/math/limits.cpp"
        "../../test/math/ring_signature.cpp"
        "../../test/math/stealth.cpp"
        "../../test/math/uint256.cpp"
        "../../test/message/address.cpp"
        "../../test/message/alert.cpp"
        "../../test/message/alert_payload.cpp"
        "../../test/message/block.cpp"
        "../../test/message/block_transactions.cpp"
        "../../test/message/compact_block.cpp"
        "../../test/message/fee_filter.cpp"
        "../../test/message/filter_add.cpp"
        "../../test/message/filter_clear.cpp"
        "../../test/message/filter_load.cpp"
        "../../test/message/get_address.cpp"
        "../../test/message/get_block_transactions.cpp"
        "../../test/message/get_blocks.cpp"
        "../../test/message/get_data.cpp"
        "../../test/message/get_headers.cpp"
        "../../test/message/header.cpp"
        "../../test/message/headers.cpp"
        "../../test/message/heading.cpp"
        "../../test/message/inventory.cpp"
        "../../test/message/inventory_vector.cpp"
        "../../test/message/memory_pool.cpp"
        "../../test/message/merkle_block.cpp"
        "../../test/message/messages.cpp"
        "../../test/message/network_address.cpp"
        "../../test/message/not_found.cpp"
        "../../test/message/ping.cpp"
        "../../test/message/pong.cpp"
        "../../test/message/prefilled_transaction.cpp"
        "../../test/message/reject.cpp"
        "../../test/message/send_compact.cpp"
        "../../test/message/send_headers.cpp"
        "../../test/message/transaction.cpp"
        "../../test/message/verack.cpp"
        "../../test/message/version.cpp"
        "../../test/unicode/unicode.cpp"
        "../../test/unicode/unicode_istream.cpp"
        "../../test/unicode/unicode_ostream.cpp"
        "../../test/utility/binary.cpp"
        "../../test/utility/collection.cpp"
        "../../test/utility/data.cpp"
        "../../test/utility/endian.cpp"
        "../../test/utility/png.cpp"
        "../../test/utility/property_tree.cpp"
        "../../test/utility/pseudo_random.cpp"
        "../../test/utility/serializer.cpp"
        "../../test/utility/stream.cpp"
        "../../test/utility/thread.cpp"
        "../../test/wallet/bitcoin_uri.cpp"
        "../../test/wallet/ec_private.cpp"
        "../../test/wallet/ec_public.cpp"
        "../../test/wallet/electrum.cpp"
        "../../test/wallet/encrypted_keys.cpp"
        "../../test/wallet/hd_private.cpp"
        "../../test/wallet/hd_public.cpp"
        "../../test/wallet/message.cpp"
        "../../test/wallet/mnemonic.cpp"
        "../../test/wallet/mnemonic.hpp"
        "../../test/wallet/payment_address.cpp"
        "../../test/wallet/qrcode.cpp"
        "../../test/wallet/select_outputs.cpp"
        "../../test/wallet/stealth_address.cpp"
        "../../test/wallet/stealth_receiver.cpp"
        "../../test/wallet/stealth_sender.cpp"
        "../../test/wallet/uri.cpp"
        "../../test/wallet/uri_reader.cpp" )

    add_test( NAME libbitcoin-test COMMAND libbitcoin-test
            --run_test=*
            --show_progress=no
            --detect_memory_leak=0
            --report_level=no
            --build_info=yes )

#     libbitcoin-test project specific include directories.
#------------------------------------------------------------------------------
    target_include_directories( libbitcoin-test PRIVATE
        "../../include" )

#     libbitcoin-test project specific libraries/linker flags.
#------------------------------------------------------------------------------
    target_link_libraries( libbitcoin-test
        ${CANONICAL_LIB_NAME}
        ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY} )

endif()

# Manage pkgconfig installation.
#------------------------------------------------------------------------------
configure_file(
  "../../libbitcoin.pc.in"
  "libbitcoin.pc" @ONLY )

install( FILES
    "${CMAKE_CURRENT_BINARY_DIR}/libbitcoin.pc"
    DESTINATION "${pkgconfigdir}" )

# Manage installation of docs.
#------------------------------------------------------------------------------
install( FILES
    "../../AUTHORS"
    "../../COPYING"
    "../../ChangeLog"
    "../../INSTALL"
    "../../NEWS"
    "../../README"
    DESTINATION share/doc/libbitcoin )

# Manage ${CANONICAL_LIB_NAME} installation.
#------------------------------------------------------------------------------
install( TARGETS ${CANONICAL_LIB_NAME}
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    PUBLIC_HEADER DESTINATION include )

# Manage include installation.
#------------------------------------------------------------------------------
install( DIRECTORY "../../include/bitcoin"
    DESTINATION include )

