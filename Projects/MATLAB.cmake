cma_end_definition()
# -----------------------------------------------------------------------------

cma_verify_executable(matlab -h)
if(UNIX)
  cma_verify_executable(csh -c exit)
endif()

find_program(CMA_MATLAB_EXECUTABLE matlab)

ExternalProject_Add(${EP_NAME}
  DOWNLOAD_COMMAND ""
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND "")
