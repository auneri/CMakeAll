# Author: Ali Uneri
# Date: 2013-05-02

cmt_end_definition()
# -----------------------------------------------------------------------------

find_package(Git REQUIRED)

set(CMT_GIT_EXECUTABLE "${GIT_EXECUTABLE}" CACHE INTERNAL "")

ExternalProject_Add(${EP_NAME}
  DOWNLOAD_COMMAND ""
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND "")
