# Author: Ali Uneri
# Date: 2013-05-02

cmt_end_definition()
# -----------------------------------------------------------------------------

cmt_verify_executable(matlab -h)
if(UNIX)
  cmt_verify_executable(csh -c exit)
endif()

find_program(CMT_MATLAB_EXECUTABLE matlab)

ExternalProject_Add(${EP_NAME}
  DOWNLOAD_COMMAND ""
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND "")
