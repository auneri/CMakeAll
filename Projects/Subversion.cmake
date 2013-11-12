# Author: Ali Uneri
# Date: 2013-05-02

cma_end_definition()
# -----------------------------------------------------------------------------

find_package(Subversion REQUIRED)

set(CMA_SVN_EXECUTABLE "${Subversion_SVN_EXECUTABLE}" CACHE INTERNAL "")

ExternalProject_Add(${EP_NAME}
  DOWNLOAD_COMMAND ""
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND "")
