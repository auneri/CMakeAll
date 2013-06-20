# Author: Ali Uneri
# Date: 2013-06-19

option(CmakeTools_RESOLVE_DEPENDENCIES "Automatically enable required dependencies" ON)
option(CmakeTools_VERIFY_URLS "Verify connection to URL locations at configuration" ON)

set(CMT_SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}")
set(CMT_CMAKE_DIR "${CMT_SOURCE_DIR}/CMake")
set(CMT_PROJECTS_DIR "${CMT_SOURCE_DIR}/Projects")
set(CMT_MODULES_DIR "${CMT_SOURCE_DIR}/Modules")

file(GLOB CMT_PROJECTS "${CMT_PROJECTS_DIR}/*.cmake")
file(GLOB CMT_MODULES "${CMT_MODULES_DIR}/*.cmake")

list(APPEND CMAKE_MODULE_PATH "${CMT_SOURCE_DIR}/CMake")
include(ExternalProject)
include(CMakeDependentOption)
include(Macros)
include(Functions)
