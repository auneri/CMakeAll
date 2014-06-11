cma_end_definition()
# -----------------------------------------------------------------------------

find_package(Hg REQUIRED)

set(CMA_HG_EXECUTABLE "${HG_EXECUTABLE}" CACHE INTERNAL "")

ExternalProject_Add(${EP_NAME}
  DOWNLOAD_COMMAND ""
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND "")
