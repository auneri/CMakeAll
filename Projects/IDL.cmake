# Author: Ali Uneri
# Date: 2013-05-02

cmt_end_definition()
# -----------------------------------------------------------------------------

find_program(
  IDL_PATH
  NAMES idl idlrt.exe
  PATHS "/usr/local/bin/idl"
  DOC "Path to IDL executable")
if(NOT IDL_PATH)
  message(FATAL_ERROR "Please specify IDL_PATH")
endif()

set(CMT_IDL_PATH "${IDL_PATH}" CACHE INTERNAL "")

ExternalProject_Add(${EP_NAME}
  DOWNLOAD_COMMAND ""
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND "")
