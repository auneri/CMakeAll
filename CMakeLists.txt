cmake_minimum_required(VERSION 2.8.7 FATAL_ERROR)

project(CMakeAll)

set(PROJECT_VERSION 1.2)

option(${PROJECT_NAME}_BUILD_DOCUMENTATION "" OFF)
option(${PROJECT_NAME}_BUILD_TESTING "" OFF)

if(${PROJECT_NAME}_BUILD_DOCUMENTATION)
  add_subdirectory(Documentation)
endif()

if(${PROJECT_NAME}_BUILD_TESTING)
  enable_testing()
  add_test(
    NAME DependencyTests
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/Testing
    COMMAND ${CMAKE_COMMAND} ${CMAKE_CURRENT_SOURCE_DIR}/Testing/DependencyTests)
endif()
