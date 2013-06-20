# Author: Ali Uneri
# Date: 2013-05-03

set(EP_REQUIRED_PROJECTS Slicer)
set(EP_OPTION_ADVANCED ON)

list(APPEND EP_MODULEPATH @BINARY_DIR@/lib/Slicer-${CMT_SLICER_VERSION}/qt-loadable-modules/@INTDIR@)

cmt_end_definition()
# -----------------------------------------------------------------------------

set(EP_SOURCE_DIR ${EP_OPTION_NAME}_SOURCE_DIR)
find_path(
  ${EP_SOURCE_DIR}
  NAMES CMakeLists.txt
  HINTS ${PROJECT_SOURCE_DIR}/Modules/${EP_NAME})
if(NOT ${EP_SOURCE_DIR})
  message(FATAL_ERROR "Please specify ${EP_SOURCE_DIR}")
endif()

set(EP_CMAKE_ARGS
  -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
  -DPYTHON_EXECUTABLE:FILEPATH=${CMT_PYTHON_EXECUTABLE}
  -DPYTHON_INCLUDE_DIR:PATH=${CMT_PYTHON_INCLUDE_DIR}
  -DPYTHON_LIBRARY:FILEPATH=${CMT_PYTHON_LIBRARY}
  -DSlicer_DIR:PATH=${PROJECT_BINARY_DIR}/Slicer-build/Slicer-build)

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
  BINARY_DIR ${PROJECT_BINARY_DIR}/Modules/${EP_NAME}-build
  # install
  INSTALL_COMMAND ""
  # test
  )
