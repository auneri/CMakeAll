cma_end_definition()
# -----------------------------------------------------------------------------

find_program(MATLAB_EXECUTABLE matlab)
if(NOT MATLAB_EXECUTABLE)
  message(FATAL_ERROR "Please specify MATLAB_EXECUTABLE")
endif()

set(CMA_MATLAB_EXECUTABLE "${MATLAB_EXECUTABLE}" CACHE INTERNAL "")

if(UNIX)
  find_program(CSH_EXECUTABLE csh)
  if(NOT CSH_EXECUTABLE)
    message(FATAL_ERROR "Please specify CSH_EXECUTABLE")
  endif()

  set(CMA_CSH_EXECUTABLE "${CSH_EXECUTABLE}" CACHE INTERNAL "")
endif()

ExternalProject_Add(${EP_NAME}
  DOWNLOAD_COMMAND ""
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND "")
