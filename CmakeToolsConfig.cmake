# Author: Ali Uneri
# Date: 2013-06-19

set(CMT_SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}")
set(CMT_CMAKE_DIR "${CMT_SOURCE_DIR}/CMake")
set(CMT_PROJECTS_DIR "${CMT_SOURCE_DIR}/Projects")

set(CMT_PROJECTS "" CACHE INTERNAL "")
set(CMT_DEFINITIONS "" CACHE INTERNAL "")

include(CMakeDependentOption)
include(CMakeParseArguments)
include(ExternalProject)

list(APPEND CMAKE_MODULE_PATH "${CMT_SOURCE_DIR}/CMake")
include(MacrosPrivate)
include(Macros)
include(FunctionsPrivate)
include(Functions)
