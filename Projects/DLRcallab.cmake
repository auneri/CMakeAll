# Author: Ali Uneri
# Date: 2013-05-02

set(EP_REQUIRED_PROJECTS IDL)

cmt_end_definition()
# -----------------------------------------------------------------------------

find_file(
  DLRcallab_PATH
  NAMES callab.sav
  DOC "Path to callab.sav")
if(NOT DLRcallab_PATH)
  message(FATAL_ERROR "Please specify DLRcallab_PATH")
endif()

set(CMT_DLRcallab_PATH "${DLRcallab_PATH}" CACHE INTERNAL "")

ExternalProject_Add(${EP_NAME}
  DEPENDS ${EP_REQUIRED_PROJECTS}
  DOWNLOAD_COMMAND ""
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND "")
