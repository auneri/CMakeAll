# Author: Ali Uneri
# Date: 2011-11-08

set(EP_REQUIRED_PROJECTS CUDA)
set(EP_REQUIRED_OPTIONS WIN32)
set(EP_OPTIONAL_PROJECTS MATLAB)

list(APPEND EP_LIBRARYPATH @BINARY_DIR@/bin)
if(PROJECTS_MATLAB)
  list(APPEND EP_REQUIRED_PROJECTS MATLAB)
  list(APPEND EP_MATLABPATH @BINARY_DIR@/Matlab)
endif()

cmt_end_definition()
# -----------------------------------------------------------------------------

set(EP_CMAKE_ARGS
  -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
  -DReconTools_HAS_MATLAB:BOOL=${PROJECTS_MATLAB}
  -DReconTools_ENABLE_CUDA20_CAPABILITY_FEATURES:BOOL=ON)

set(EP_SOURCE_DIR ${EP_OPTION_NAME}_SOURCE_DIR)
find_path(
  ${EP_SOURCE_DIR}
  NAMES CMakeLists.txt
  NO_DEFAULT_PATH)
if(NOT ${EP_SOURCE_DIR})
  message(FATAL_ERROR "Please specify ${EP_SOURCE_DIR}")
endif()

ExternalProject_Add(${EP_NAME}
  DEPENDS ${EP_REQUIRED_PROJECTS}
  # download
  DOWNLOAD_COMMAND ""
  # patch
  # update
  # configure
  SOURCE_DIR ${${EP_SOURCE_DIR}}
  CMAKE_ARGS ${EP_CMAKE_ARGS}
  # build
  BINARY_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}-build
  # install
  # test
  )
