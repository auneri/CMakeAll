cma_end_definition()
# -----------------------------------------------------------------------------

find_package(PythonInterp REQUIRED)

find_package(PythonLibs ${PYTHON_VERSION_STRING} EXACT REQUIRED)

ExternalProject_Add(${EP_NAME}
  DOWNLOAD_COMMAND ""
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND "")

set(PYTHON_EXECUTABLE "${PYTHON_EXECUTABLE}" CACHE INTERNAL "")
set(PYTHON_INCLUDE_DIR "${PYTHON_INCLUDE_DIR}" CACHE INTERNAL "")
set(PYTHON_LIBRARY "${PYTHON_RELEASE_LIBRARY}" CACHE INTERNAL "")
