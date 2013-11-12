set(CMA_SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}")
set(CMA_CMAKE_DIR "${CMA_SOURCE_DIR}/CMake")
set(CMA_PROJECTS_DIR "${CMA_SOURCE_DIR}/Projects")

set(CMA_PROJECTS "" CACHE INTERNAL "")
set(CMA_DEFINITIONS "" CACHE INTERNAL "")

include(CMakeDependentOption)
include(CMakeParseArguments)
include(ExternalProject)

list(APPEND CMAKE_MODULE_PATH "${CMA_CMAKE_DIR}")
include(MacrosPrivate)
include(Macros)
include(FunctionsPrivate)
include(Functions)
