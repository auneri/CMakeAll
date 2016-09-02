set(EP_REQUIRED_PROJECTS Git)
set(EP_URL "git://github.com/opencv/opencv.git")
set(EP_OPTION_DESCRIPTION "Open Source Computer Vision")

cma_envvar(@LIBRARYPATH@ PREPEND "@BINARY_DIR@/@LIBDIR@/@INTDIR@")

cma_list(APPEND EP_REQUIRED_PROJECTS Python IF PROJECTS_Python)

cma_end_definition()
# -----------------------------------------------------------------------------

set(EP_CMAKE_ARGS
  -DBUILD_DOCS:BOOL=OFF
  -DBUILD_opencv_gpu:BOOL=${PROJECTS_CUDA}
  -DBUILD_opencv_python:BOOL=${PROJECTS_Python}
  -DBUILD_PACKAGE:BOOL=OFF
  -DBUILD_PERF_TESTS:BOOL=OFF
  -DBUILD_TESTS:BOOL=OFF
  -DBUILD_WITH_DEBUG_INFO:BOOL=OFF
  -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
  -DCMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
  -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
  -DWITH_CUDA:BOOL=OFF
  -DWITH_FFMPEG:BOOL=OFF
  -DWITH_OPENCL:BOOL=OFF
  -DWITH_QT:BOOL=${PROJECTS_Qt})

if(PROJECTS_Python)
  list(APPEND EP_CMAKE_ARGS
    -DPYTHON_EXECUTABLE:FILEPATH=${PYTHON_EXECUTABLE}
    -DPYTHON_INCLUDE_DIR:PATH=${PYTHON_INCLUDE_DIR}
    -DPYTHON_LIBRARY:FILEPATH=${PYTHON_LIBRARY})
endif()

ExternalProject_Add(${EP_NAME}
  DEPENDS ${EP_REQUIRED_PROJECTS}
  GIT_REPOSITORY ${EP_URL}
  GIT_TAG 2.4.13
  UPDATE_COMMAND ""
  SOURCE_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}
  CMAKE_ARGS ${EP_CMAKE_ARGS}
  BINARY_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}-build
  INSTALL_COMMAND "")
