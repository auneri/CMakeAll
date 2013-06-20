# Author: Ali Uneri
# Date: 2013-05-02

set(EP_REQUIRED_PROJECTS ITK)

list(APPEND EP_PATH @BINARY_DIR@/Applications/@INTDIR@)
list(APPEND EP_LIBRARYPATH @BINARY_DIR@/Library/@INTDIR@)

cmt_end_definition()
# -----------------------------------------------------------------------------

set(EP_CMAKE_ARGS
  -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
  -DITK_DIR:PATH=${PROJECT_BINARY_DIR}/ITK-build
  -DItkTools_BUILD_TESTING:BOOL=${CMT_BUILD_TESTING})

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
