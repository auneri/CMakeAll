cma_end_definition()
# -----------------------------------------------------------------------------

find_package(CUDA REQUIRED)

ExternalProject_Add(${EP_NAME}
  DOWNLOAD_COMMAND ""
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND "")
