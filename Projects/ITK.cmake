set(EP_REQUIRED_PROJECTS Git)
set(EP_URL "git://itk.org/ITK.git")
set(EP_OPTION_DESCRIPTION "Insight Segmentation and Registration Toolkit")

cma_list(APPEND EP_REQUIRED_PROJECTS CUDA IF PROJECTS_CUDA)
cma_list(APPEND EP_REQUIRED_PROJECTS VTK IF PROJECTS_VTK)
cma_list(APPEND EP_REQUIRED_PROJECTS zlib IF PROJECTS_zlib)

cma_envvar(@LIBRARYPATH@ PREPEND "@BINARY_DIR@/@LIBDIR@/@INTDIR@")

cma_end_definition()
# -----------------------------------------------------------------------------

if(WIN32)
  string(LENGTH "${PROJECT_BINARY_DIR}/${EP_NAME}-build" LENGTH)
  if(LENGTH GREATER 50)
    message(FATAL_ERROR "Shorter path for ${PROJECT_NAME} build directory is required, since ITK path is ${LENGTH} > 50 characters")
  endif()
endif()

set(EP_CMAKE_ARGS
  -DBUILD_EXAMPLES:BOOL=OFF
  -DBUILD_TESTING:BOOL=OFF
  -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
  -DCMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
  -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
  -DITKV3_COMPATIBILITY:BOOL=ON
  -DITK_USE_GPU:BOOL=${PROJECTS_CUDA}
  -DITK_USE_REVIEW:BOOL=ON
  -DITK_USE_SYSTEM_ZLIB:BOOL=${PROJECTS_zlib}
  -DModule_ITKVtkGlue:BOOL=${PROJECTS_VTK})

if(PROJECTS_SimpleITK OR PROJECTS_Slicer)
  list(APPEND EP_CMAKE_ARGS -DBUILD_SHARED_LIBS:BOOL=ON)
else()
  list(APPEND EP_CMAKE_ARGS -DBUILD_SHARED_LIBS:BOOL=OFF)
endif()
if(PROJECTS_VTK)
  list(APPEND EP_CMAKE_ARGS -DVTK_DIR:PATH=${PROJECT_BINARY_DIR}/VTK-build)
endif()
if(PROJECTS_zlib)
  list(APPEND EP_CMAKE_ARGS
    -DZLIB_ROOT:PATH=${ZLIB_ROOT}
    -DZLIB_INCLUDE_DIR:PATH=${ZLIB_INCLUDE_DIR}
    -DZLIB_LIBRARY:FILEPATH=${ZLIB_LIBRARY})
endif()

ExternalProject_Add(${EP_NAME}
  DEPENDS ${EP_REQUIRED_PROJECTS}
  # download
  GIT_REPOSITORY ${EP_URL}
  GIT_TAG v4.8.2
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
