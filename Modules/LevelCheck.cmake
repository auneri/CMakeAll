# Author: Ali Uneri
# Date: 2013-05-03

set(EP_REQUIRED_PROJECTS CUDA mlabwrap Main)
set(EP_REQUIRED_OPTIONS WIN32)

list(APPEND EP_MODULEPATH @SOURCE_DIR@)

cmt_end_definition()
# -----------------------------------------------------------------------------

set(EP_SOURCE_DIR ${EP_OPTION_NAME}_SOURCE_DIR)
find_path(
  ${EP_SOURCE_DIR}
  NAMES ${EP_NAME}.py
  HINTS ${PROJECT_SOURCE_DIR}/Modules/${EP_NAME})
if(NOT ${EP_SOURCE_DIR})
  message(FATAL_ERROR "Please specify ${EP_SOURCE_DIR}")
endif()

ExternalProject_Add(${EP_NAME}
  DEPENDS ${EP_REQUIRED_PROJECTS}
  DOWNLOAD_COMMAND ""
  SOURCE_DIR ${${EP_SOURCE_DIR}}
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND "")
