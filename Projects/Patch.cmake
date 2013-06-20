# Author: Ali Uneri
# Date: 2013-05-02

cmt_end_definition()
# -----------------------------------------------------------------------------

cmt_verify_executable(patch --help)

set(CMT_PATCH_EXECUTABLE "patch" CACHE INTERNAL "")

ExternalProject_Add(${EP_NAME}
  DOWNLOAD_COMMAND ""
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND "")
