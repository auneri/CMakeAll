cma_end_definition()
# -----------------------------------------------------------------------------

find_program(PATCH_EXECUTABLE patch)
if(NOT PATCH_EXECUTABLE)
  message(FATAL_ERROR "Please specify PATCH_EXECUTABLE")
endif()

set(CMA_PATCH_EXECUTABLE "${PATCH_EXECUTABLE}" CACHE INTERNAL "")

ExternalProject_Add(${EP_NAME}
  DOWNLOAD_COMMAND ""
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND "")
