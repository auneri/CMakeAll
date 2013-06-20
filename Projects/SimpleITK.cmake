# Author: Ali Uneri
# Date: 2012-10-29

set(EP_REQUIRED_PROJECTS ITK SWIG)
set(EP_OPTIONAL_PROJECTS VTK)
set(EP_URL git://itk.org/SimpleITK.git)

list(APPEND EP_LIBRARYPATH @BINARY_DIR@/lib)
list(APPEND EP_PYTHONPATH
  @BINARY_DIR@/lib
  @BINARY_DIR@/Wrapping)

if(PROJECTS_VTK)
  list(APPEND EP_REQUIRED_PROJECTS Patch VTK)
  set(EP_PATCH ${CMAKE_CURRENT_LIST_DIR}/Patches/${EP_NAME}.patch)
endif()

cmt_end_definition()
# -----------------------------------------------------------------------------

set(EP_REVISION v0.6.1)
set(EP_CMAKE_ARGS
  -DBUILD_TESTING:BOOL=OFF
  -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
  -DITK_DIR:PATH=${PROJECT_BINARY_DIR}/ITK-build
  -DPYTHON_EXECUTABLE:FILEPATH=${CMT_PYTHON_EXECUTABLE}
  -DPYTHON_INCLUDE_DIR:PATH=${CMT_PYTHON_INCLUDE_DIR}
  -DSWIG_DIR:PATH=${CMT_SWIG_DIR}
  -DSWIG_EXECUTABLE:FILEPATH=${CMT_SWIG_EXECUTABLE}
  -DSWIG_VERSION:STRING=${CMT_SWIG_VERSION}
  -DWRAP_CSHARP:BOOL=OFF
  -DWRAP_JAVA:BOOL=OFF
  -DWRAP_LUA:BOOL=OFF
  -DWRAP_PYTHON:BOOL=ON
  -DWRAP_R:BOOL=OFF
  -DWRAP_RUBY:BOOL=OFF
  -DWRAP_TCL:BOOL=OFF)

if(PROJECTS_VTK)
  list(APPEND EP_CMAKE_ARGS
    -DVTK_DIR:PATH=${PROJECT_BINARY_DIR}/VTK-build)
else()
  list(APPEND EP_CMAKE_ARGS
    -DVTK_DIR:PATH="")
endif()

ExternalProject_Add(${EP_NAME}
  DEPENDS ${EP_REQUIRED_PROJECTS}
  # download
  GIT_REPOSITORY ${EP_URL}
  GIT_TAG ${EP_REVISION}
  # patch
  # update
  UPDATE_COMMAND ""
  # configure
  SOURCE_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}
  CMAKE_ARGS ${EP_CMAKE_ARGS}
  # build
  BINARY_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}-build
  # install
  INSTALL_COMMAND ""
  # test
  )
