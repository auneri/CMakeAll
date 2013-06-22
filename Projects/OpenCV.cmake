# Author: Ali Uneri
# Date: 2011-07-25

set(EP_REQUIRED_PROJECTS Git)
set(EP_URL git://github.com/Itseez/opencv.git)
set(EP_OPTION_DESCRIPTION "Open Source Computer Vision")

list(APPEND EP_LIBRARYPATH @BINARY_DIR@/@LIBDIR@/@INTDIR@)

if(PROJECTS_Python)
  list(APPEND EP_REQUIRED_PROJECTS Python)
endif()

cmt_end_definition()
# -----------------------------------------------------------------------------

set(EP_REVISION 2.4.5)
set(EP_CMAKE_ARGS
  -DBUILD_DOCS:BOOL=OFF
  -DBUILD_opencv_python:BOOL=${PROJECTS_Python}
  -DBUILD_TESTS:BOOL=OFF
  -DBUILD_WITH_DEBUG_INFO:BOOL=OFF
  -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
  -DWITH_CUDA:BOOL=OFF
  -DWITH_QT:BOOL=OFF)

if(PROJECTS_Python)
  list(APPEND EP_CMAKE_ARGS
    -DPYTHON_EXECUTABLE:FILEPATH=${CMT_PYTHON_EXECUTABLE}
    -DPYTHON_INCLUDE_DIR:PATH=${CMT_PYTHON_INCLUDE_DIR}
    -DPYTHON_LIBRARY:FILEPATH=${CMT_PYTHON_LIBRARY})
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
