cma_end_definition()
# -----------------------------------------------------------------------------

find_package(PythonInterp REQUIRED)

if(APPLE AND PYTHON_EXECUTABLE MATCHES "^/opt/local/bin/")
  set(PYTHON_INCLUDE_DIR "/opt/local/Library/Frameworks/Python.framework/Headers" CACHE PATH "")
  set(PYTHON_LIBRARY "/opt/local/Library/Frameworks/Python.framework/Versions/Current/Python" CACHE PATH "")
endif()

find_package(PythonLibs ${PYTHON_VERSION_STRING} REQUIRED)

set(PYTHON_RELEASE_LIBRARY ${PYTHON_LIBRARY})
if(WIN32)
  list(GET PYTHON_LIBRARY 0 IS_OPTIMIZED)
  if(${IS_OPTIMIZED} STREQUAL "optimized")
    list(GET PYTHON_LIBRARY 1 PYTHON_RELEASE_LIBRARY)
  endif()
endif()

ExternalProject_Add(${EP_NAME}
  DOWNLOAD_COMMAND ""
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND "")

set(PYTHON_EXECUTABLE "${PYTHON_EXECUTABLE}" CACHE INTERNAL "")
set(PYTHON_INCLUDE_DIR "${PYTHON_INCLUDE_DIR}" CACHE INTERNAL "")
set(PYTHON_LIBRARY "${PYTHON_RELEASE_LIBRARY}" CACHE INTERNAL "")
