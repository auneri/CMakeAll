cma_end_definition()
# -----------------------------------------------------------------------------

find_package(Git REQUIRED)

ExternalProject_Add(${EP_NAME}
  DOWNLOAD_COMMAND ""
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND "")

set(GIT_EXECUTABLE "${GIT_EXECUTABLE}" CACHE INTERNAL "")
