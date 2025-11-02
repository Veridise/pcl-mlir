cmake_minimum_required(VERSION 3.23)

if (NOT DEFINED PCL_VERSION_OVERRIDE)
  include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/GitVersion.cmake)
  get_git_version(PCL_VERSION "0.1.0") # default version
else()
  message(STATUS "PCL_VERSION_OVERRIDE specified, setting version to ${PCL_VERSION_OVERRIDE}")
  set(PCL_VERSION "${PCL_VERSION_OVERRIDE}")
endif()

project(
  PCL
  # Keeping this description short since it's also used by doxygen
  DESCRIPTION
    "Picus's Constraint Language"
  VERSION "${PCL_VERSION}"
  HOMEPAGE_URL https://github.com/Veridise/pcl-mlir)

option(PCL_TEMPLATE_BACKTRACE_LIMIT
       "Add -ftemplate-backtrace-limit=0 to the compile flags")

include(GNUInstallDirs)

set(CMAKE_CXX_STANDARD
    20
    CACHE STRING "C++ standard")
set(CMAKE_CXX_STANDARD_REQUIRED
    ON
    CACHE STRING "")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")

# Use same policy as LLVM to suppress warnings
if(POLICY CMP0116)
  cmake_policy(SET CMP0116 OLD)
endif()

set(CMAKE_EXPORT_COMPILE_COMMANDS
    ON
    CACHE INTERNAL "")

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/FeatureTests.cmake)
# Dependency setup

find_package(LLVM 20.1 REQUIRED CONFIG)
find_package(MLIR REQUIRED CONFIG)

message(STATUS "Using LLVM in: ${LLVM_DIR}")
message(STATUS "Using MLIR in: ${MLIR_DIR}")

# Adds an INTERFACE library that only includes headers
function(add_header_library _name _include_dirs _export_name)
  add_library(${_name} INTERFACE)
  target_include_directories(${_name} SYSTEM INTERFACE ${_include_dirs})
  install(TARGETS ${_name} EXPORT ${_export_name})
endfunction()

set(PCL_EXPORT_TARGETS "PCLTargets")
# LLVM & MLIR do not propagate their include dirs correctly. We define them as
# INTERFACE libraries and link against them
add_header_library(LLVMHeaders ${LLVM_INCLUDE_DIRS} ${PCL_EXPORT_TARGETS})
add_header_library(MLIRHeaders ${MLIR_INCLUDE_DIRS} ${PCL_EXPORT_TARGETS})

list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
list(APPEND CMAKE_MODULE_PATH "${MLIR_CMAKE_DIR}")
include(TableGen)
include(AddLLVM)
include(AddMLIR)
include(HandleLLVMOptions)

separate_arguments(LLVM_DEFINITIONS_LIST NATIVE_COMMAND ${LLVM_DEFINITIONS})
add_definitions(${LLVM_DEFINITIONS_LIST})
add_compile_options(
  -Werror=switch
  -Werror=return-type
  -Wall
  -Wextra
  -Wno-unused-parameter
  -Wshadow
  -Wnon-virtual-dtor
  -pedantic
  -fno-omit-frame-pointer)

if(CMAKE_CONFIGURATION_TYPES)
  list(APPEND CMAKE_CONFIGURATION_TYPES DebWithSans)
  list(REMOVE_DUPLICATES CMAKE_CONFIGURATION_TYPES)
endif()

set(PCL_LIT_COMPATIBLE_COVERAGE
    OFF
    CACHE INTERNAL "")

if(CMAKE_BUILD_TYPE STREQUAL "Debug" OR CMAKE_BUILD_TYPE STREQUAL "DebWithSans")
  if(PCL_LIT_COMPATIBLE_COVERAGE)
    message(FATAL_ERROR "Don't manually set PCL_LIT_COMPATIBLE_COVERAGE.")
  endif()
  if(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
    message(STATUS "Adding coverage flags")
    add_compile_options(-fprofile-instr-generate -fcoverage-mapping)
    add_link_options(-fprofile-instr-generate -fcoverage-mapping)
    set(PCL_LIT_COMPATIBLE_COVERAGE ON)
    message(
      STATUS "PCL_LIT_COMPATIBLE_COVERAGE=${PCL_LIT_COMPATIBLE_COVERAGE}")
  elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    message(WARNING "Gcov reports are not supported by the test environment.")
    message(WARNING "Set PCL_FORCE_GCC_COVERAGE to enable coverage in GCC.")
    if(PCL_FORCE_GCC_COVERAGE)
      add_compile_options(--coverage -O0 -g)
      add_link_options(--coverage)
    endif()
  else()
    message(
      WARNING
        "Coverage requested but ${CMAKE_CXX_COMPILER_ID} is not a supported compiler and coverage will not be applied."
    )
  endif()

  add_compile_options(-O0 -g)
endif()

if(CMAKE_BUILD_TYPE STREQUAL "DebWithSans")
  # NOTE: undefined behavior sanitizer ("undefined") has been removed due to its
  # poor interaction with gtest fixtures and other standard MLIR/LLVM operations.
  add_compile_options(-fsanitize=address)
  add_link_options(-fsanitize=address)
  # LeakSanitizer is not supported on all platforms (notably, MacOS)
  include(CheckCXXCompilerFlag)
  check_cxx_compiler_flag("-fsanitize=leak" HAS_FSANITIZE_LEAK)
  if(HAS_FSANITIZE_LEAK)
    add_compile_options(-fsanitize=leak)
    add_link_options(-fsanitize=leak)
  endif()
endif()

if(PCL_TEMPLATE_BACKTRACE_LIMIT)
  add_compile_options(-ftemplate-backtrace-limit=0)
endif()

# We need the include dir so we can pass it to mlir-tblgen
set(PCL_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/include")


include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/PCLMacros.cmake)

# Create an empty list for the dialect libraries, to be populated in the lib
# subdirectory.
add_library(LLZKAllDialects INTERFACE)
add_library(LLZK::AllDialects ALIAS LLZKAllDialects)
# Ensures that the target can be imported as "LLZK::AllDialects" and not
# "LLZK::LLZKAllDialects"
set_target_properties(LLZKAllDialects PROPERTIES EXPORT_NAME "AllDialects")
install(TARGETS LLZKAllDialects EXPORT LLZKTargets)

add_subdirectory(include)
add_subdirectory(lib)
add_subdirectory(tools)


# Tests

# lit tests
include(CTest)
enable_testing()
set(CMAKE_CTEST_ARGUMENTS
    "--output-on-failure"
    CACHE STRING "CTest arguments")
if(BUILD_TESTING)
  add_subdirectory(test)
endif()

find_package(GTest)
if(BUILD_TESTING AND GTest_FOUND)
  message(STATUS "gtest found, enabling unit tests...")
  include(GoogleTest)

  add_custom_target(PCLUnitTests)

  if(${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.20")
    set(GTEST_LIB_TARGETS "GTest::gtest;GTest::gmock")
    set(GTEST_EXE_TARGET GTest::gtest_main)
  else()
    set(GTEST_LIB_TARGETS GTest::GTest)
    set(GTEST_EXE_TARGET GTest::Main)
  endif()

  add_subdirectory(unittests)
elseif(BUILD_TESTING)
  message(STATUS "gtest not found, unit tests will not be run")
else()
  message(STATUS "Unit tests are disabled")
endif()

# Catch-all target for running all tests
add_custom_target(
  check
  DEPENDS # test targets may not exist if BUILD_TESTING is off
          $<$<BOOL:BUILD_TESTING>:check-unit>
          $<$<BOOL:BUILD_TESTING>:check-lit>)

# Install

export(
  EXPORT ${PCL_EXPORT_TARGETS}
  FILE ${CMAKE_CURRENT_BINARY_DIR}/${PCL_EXPORT_TARGETS}.cmake
  NAMESPACE PCL::)
install(
  EXPORT ${PCL_EXPORT_TARGETS}
  NAMESPACE PCL::
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/PCL)

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/PCLConfigVersion.cmake"
  VERSION "${PROJECT_VERSION}"
  COMPATIBILITY AnyNewerVersion)
configure_package_config_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/cmake/PCLConfig.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/PCLConfig.cmake"
  INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/PCL")
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/PCLConfig.cmake"
              "${CMAKE_CURRENT_BINARY_DIR}/PCLConfigVersion.cmake"
        DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/PCL")