cmake_minimum_required(VERSION 2.8.7)

project(CmakeTools)

set(PROJECT_VERSION 1.0)

option(${PROJECT_NAME}_BUILD_DOCUMENTATION "" OFF)

if(${PROJECT_NAME}_BUILD_DOCUMENTATION)
  add_subdirectory(Documentation)
endif()
