set(EP_REQUIRED_PROJECTS Git)
set(EP_URL git://itk.org/ITK.git)
set(EP_OPTION_DESCRIPTION "Insight Segmentation and Registration Toolkit")

list(APPEND EP_LIBRARYPATH @BINARY_DIR@/bin/@INTDIR@)

if(PROJECTS_CUDA)
  list(APPEND EP_REQUIRED_PROJECTS CUDA Patch)
  set(EP_PATCH ${CMAKE_CURRENT_LIST_DIR}/Patches/${EP_NAME}.patch)
endif()
if(PROJECTS_DCMTK)
  list(APPEND EP_REQUIRED_PROJECTS DCMTK)
endif()
if(PROJECTS_VTK)
  list(APPEND EP_REQUIRED_PROJECTS VTK)
endif()
if(PROJECTS_zlib)
  list(APPEND EP_REQUIRED_PROJECTS zlib)
endif()

cma_end_definition()
# -----------------------------------------------------------------------------

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
  -DModule_ITKIODCMTK:BOOL=${PROJECTS_DCMTK}
  -DModule_ITKVtkGlue:BOOL=${PROJECTS_VTK})

if(PROJECTS_DCMTK)
  list(APPEND EP_CMAKE_ARGS
    -DITK_USE_SYSTEM_DCMTK:BOOL=ON
    -DDCMTK_DIR:PATH=${PROJECT_BINARY_DIR}/DCMTK-build)
endif()
if(PROJECTS_SimpleITK OR PROJECTS_Slicer)
  list(APPEND EP_CMAKE_ARGS -DBUILD_SHARED_LIBS:BOOL=ON)
else()
  list(APPEND EP_CMAKE_ARGS -DBUILD_SHARED_LIBS:BOOL=OFF)
endif()
if(PROJECTS_VTK)
  list(APPEND EP_CMAKE_ARGS
    -DVTK_DIR:PATH=${PROJECT_BINARY_DIR}/VTK-build)
endif()
if(PROJECTS_zlib)
  list(APPEND EP_CMAKE_ARGS
    -DZLIB_ROOT:PATH=${CMA_ZLIB_ROOT}
    -DZLIB_INCLUDE_DIR:PATH=${CMA_ZLIB_INCLUDE_DIR}
    -DZLIB_LIBRARY:FILEPATH=${CMA_ZLIB_LIBRARY})
endif()

ExternalProject_Add(${EP_NAME}
  DEPENDS ${EP_REQUIRED_PROJECTS}
  # download
  GIT_REPOSITORY ${EP_URL}
  GIT_TAG v4.5.0
  # patch
  # update
  # configure
  SOURCE_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}
  CMAKE_ARGS ${EP_CMAKE_ARGS}
  # build
  BINARY_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}-build
  # install
  INSTALL_COMMAND ""
  # test
  )
