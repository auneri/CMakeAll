cma_end_definition()
# -----------------------------------------------------------------------------

find_package(Hg REQUIRED)

ExternalProject_Add(${EP_NAME}
  DOWNLOAD_COMMAND ""
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND "")

set(CMA_HG_EXECUTABLE "${HG_EXECUTABLE}" CACHE INTERNAL "")
