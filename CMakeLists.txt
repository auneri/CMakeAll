cmake_minimum_required(VERSION 2.8)

project(CmakeTools NONE)

option(${PROJECT_NAME}_BUILD_DOCUMENTATION "" OFF)

if(${PROJECT_NAME}_BUILD_DOCUMENTATION)
  add_subdirectory(Documentation)
endif()
