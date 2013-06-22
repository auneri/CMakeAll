# Author: Ali Uneri
# Date: 2013-06-21

set(EP_REQUIRED_PROJECTS cisst OpenCV PythonTools Slicer)

list(APPEND EP_MODULEPATH
  @BINARY_DIR@/lib/Slicer-${CMT_SLICER_VERSION}/qt-loadable-modules/@INTDIR@
  @SOURCE_DIR@/Calibration
  @SOURCE_DIR@/FiducialRegistration
  @SOURCE_DIR@/SliceNavigation
  @SOURCE_DIR@/Tracking)

cmt_end_definition()
# -----------------------------------------------------------------------------

set(EP_SOURCE_DIR ${EP_OPTION_NAME}_SOURCE_DIR)
get_filename_component(PARENT_DIR ${PROJECT_SOURCE_DIR} PATH)
find_path(
  ${EP_SOURCE_DIR}
  NAMES CMakeLists.txt
  HINTS ${PARENT_DIR}/${EP_NAME}
  NO_DEFAULT_PATH)
if(NOT ${EP_SOURCE_DIR})
  message(FATAL_ERROR "Please specify ${EP_SOURCE_DIR}")
endif()

set(EP_CMAKE_ARGS
  -Dcisst_DIR:PATH=${PROJECT_BINARY_DIR}/cisst-build/cisst
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
  BINARY_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}-build
  # install
  INSTALL_COMMAND ""
  # test
  )
