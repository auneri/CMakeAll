cma_end_definition()
# -----------------------------------------------------------------------------

find_package(Git REQUIRED)

set(CMA_GIT_EXECUTABLE "${GIT_EXECUTABLE}" CACHE INTERNAL "")

ExternalProject_Add(${EP_NAME}
  DOWNLOAD_COMMAND ""
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND "")
