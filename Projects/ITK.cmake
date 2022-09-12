set(EP_REQUIRED_PROJECTS Git)
set(EP_URL "https://github.com/InsightSoftwareConsortium/ITK.git")
set(EP_OPTION_DESCRIPTION "Insight Segmentation and Registration Toolkit")

cma_list(APPEND EP_REQUIRED_PROJECTS CUDA IF ${EP_OPTION_NAME}_GPU)
cma_list(APPEND EP_REQUIRED_PROJECTS SWIG IF ${EP_OPTION_NAME}_Python)
cma_list(APPEND EP_REQUIRED_PROJECTS VTK IF ${EP_OPTION_NAME}_VtkGlue)
cma_list(APPEND EP_REQUIRED_PROJECTS zlib IF PROJECTS_zlib)

if(${EP_OPTION_NAME}_Python)
  cma_envvar(@LIBRARYPATH@ PREPEND
    "@BINARY_DIR@/@LIBDIR@/@INTDIR@")
  cma_envvar(PYTHONPATH PREPEND
    "@BINARY_DIR@/lib"
    "@BINARY_DIR@/lib/@INTDIR@"
    "@BINARY_DIR@/Wrapping/Generators/Python/@INTDIR@")
endif()

cma_end_definition()
# -----------------------------------------------------------------------------

cmake_dependent_option(${EP_OPTION_NAME}_GPU "Enable OpenCL support" OFF ${EP_OPTION_NAME} OFF)
cmake_dependent_option(${EP_OPTION_NAME}_Python "Enable Python bindings" OFF ${EP_OPTION_NAME} OFF)
cmake_dependent_option(${EP_OPTION_NAME}_VtkGlue "Enable ITKVtkGlue module" OFF ${EP_OPTION_NAME} OFF)

if(WIN32)
  string(LENGTH "${PROJECT_BINARY_DIR}/${EP_NAME}-build" LENGTH)
  if(LENGTH GREATER 50)
    message(FATAL_ERROR "Shorter path for ${PROJECT_NAME} build directory is required, since ITK path is ${LENGTH} > 50 characters")
  endif()
endif()

set(EP_CMAKE_ARGS
  -DBUILD_EXAMPLES:BOOL=OFF
  -DBUILD_SHARED_LIBS:BOOL=${${EP_OPTION_NAME}_Python}
  -DBUILD_TESTING:BOOL=OFF
  -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
  -DCMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
  -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
  -DITK_LEGACY_SILENT:BOOL=${${EP_OPTION_NAME}_Python}
  -DITK_USE_GPU:BOOL=${${EP_OPTION_NAME}_GPU}
  -DITK_USE_REVIEW:BOOL=ON
  -DITK_USE_SYSTEM_SWIG:BOOL=${${EP_OPTION_NAME}_Python}
  -DITK_USE_SYSTEM_ZLIB:BOOL=${PROJECTS_zlib}
  -DITK_WRAP_PYTHON:BOOL=${${EP_OPTION_NAME}_Python}
  -DITKV3_COMPATIBILITY:BOOL=ON
  -DModule_ITKVtkGlue:BOOL=${${EP_OPTION_NAME}_VtkGlue})

if(${EP_OPTION_NAME}_Python)
  list(APPEND EP_CMAKE_ARGS
    -DPYTHON_EXECUTABLE:PATH=${PYTHON_EXECUTABLE}
    -DPYTHON_INCLUDE_DIR:PATH=${PYTHON_INCLUDE_DIR}
    -DPYTHON_LIBRARY:FILEPATH=${PYTHON_LIBRARY}
    -DSWIG_DIR:PATH=${SWIG_DIR}
    -DSWIG_EXECUTABLE:FILEPATH=${SWIG_EXECUTABLE}
    -DSWIG_VERSION:STRING=${SWIG_VERSION})
endif()
if(${EP_OPTION_NAME}_VtkGlue)
  list(APPEND EP_CMAKE_ARGS
    -DVTK_DIR:PATH=${PROJECT_BINARY_DIR}/VTK-build)
endif()
if(PROJECTS_zlib)
  list(APPEND EP_CMAKE_ARGS
    -DZLIB_ROOT:PATH=${ZLIB_ROOT}
    -DZLIB_INCLUDE_DIR:PATH=${ZLIB_INCLUDE_DIR}
    -DZLIB_LIBRARY:FILEPATH=${ZLIB_LIBRARY})
endif()

ExternalProject_Add(${EP_NAME}
  DEPENDS ${EP_REQUIRED_PROJECTS}
  GIT_REPOSITORY ${EP_URL}
  GIT_TAG "v5.1.1"
  GIT_SHALLOW ON
  SOURCE_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}
  CMAKE_ARGS ${EP_CMAKE_ARGS}
  BINARY_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}-build
  INSTALL_COMMAND "")
