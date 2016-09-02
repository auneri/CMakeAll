cma_end_definition()
# -----------------------------------------------------------------------------

find_package(Subversion REQUIRED)

ExternalProject_Add(${EP_NAME}
  DOWNLOAD_COMMAND ""
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND "")

set(Subversion_SVN_EXECUTABLE "${Subversion_SVN_EXECUTABLE}" CACHE INTERNAL "")
