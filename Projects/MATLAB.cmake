cma_end_definition()
# -----------------------------------------------------------------------------

find_program(MATLAB_EXECUTABLE matlab)
if(NOT MATLAB_EXECUTABLE)
  message(FATAL_ERROR "Please specify MATLAB_EXECUTABLE")
endif()

get_filename_component(MATLAB_BIN_DIR ${MATLAB_EXECUTABLE} PATH)
get_filename_component(MATLAB_DIR ${MATLAB_BIN_DIR} PATH)

ExternalProject_Add(${EP_NAME}
  DOWNLOAD_COMMAND ""
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND "")

set(MATLAB_EXECUTABLE "${MATLAB_EXECUTABLE}" CACHE INTERNAL "")
set(MATLAB_DIR "${MATLAB_DIR}" CACHE INTERNAL "")
