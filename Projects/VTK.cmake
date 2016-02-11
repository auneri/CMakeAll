set(EP_REQUIRED_PROJECTS Git)
set(EP_URL "git://vtk.org/VTK.git")
set(EP_OPTION_DESCRIPTION "Visualization Toolkit")

cma_list(APPEND EP_REQUIRED_PROJECTS Python IF PROJECTS_Python)
cma_list(APPEND EP_REQUIRED_PROJECTS Qt IF PROJECTS_Qt)
cma_list(APPEND EP_REQUIRED_PROJECTS zlib IF PROJECTS_zlib)

cma_envvar(@LIBRARYPATH@ PREPEND "@BINARY_DIR@/@LIBDIR@/@INTDIR@")
cma_envvar(PYTHONPATH PREPEND
  "@BINARY_DIR@/@LIBDIR@/@INTDIR@"
  "@BINARY_DIR@/Wrapping/Python")

cma_end_definition()
# -----------------------------------------------------------------------------

cmake_dependent_option(${EP_OPTION_NAME}_DEBUG_LEAKS "Build leak checking support into VTK" OFF ${EP_OPTION_NAME} OFF)
cmake_dependent_option(${EP_OPTION_NAME}_TDx "Support for 3DConnexion devices" OFF ${EP_OPTION_NAME} OFF)

set(EP_CMAKE_ARGS
  -DBUILD_EXAMPLES:BOOL=OFF
  -DBUILD_SHARED_LIBS:BOOL=${PROJECTS_Python}
  -DBUILD_TESTING:BOOL=OFF
  -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
  -DCMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
  -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
  -DModule_vtkTestingRendering:BOOL=ON
  -DVTK_DEBUG_LEAKS:BOOL=${${EP_OPTION_NAME}_DEBUG_LEAKS}
  -DVTK_USE_DISPLAY:BOOL=OFF
  -DVTK_USE_GUISUPPORT:BOOL=${PROJECTS_Qt}
  -DVTK_USE_PARALLEL:BOOL=ON
  -DVTK_Group_Qt:BOOL=${PROJECTS_Qt}
  -DVTK_USE_QT:BOOL=${PROJECTS_Qt}
  -DVTK_USE_QVTK_QTOPENGL:BOOL=${PROJECTS_Qt}
  -DVTK_USE_SYSTEM_ZLIB:BOOL=${PROJECTS_zlib}
  -DVTK_USE_TDX:BOOL=${${EP_OPTION_NAME}_TDx}
  -DVTK_USE_TK:BOOL=OFF
  -DVTK_WRAP_PYTHON:BOOL=${PROJECTS_Python})

if(APPLE)
  list(APPEND EP_CMAKE_ARGS
    -DVTK_REQUIRED_OBJCXX_FLAGS:STRING=
    -DVTK_USE_CARBON:BOOL=OFF
    -DVTK_USE_COCOA:BOOL=ON
    -DVTK_USE_X:BOOL=OFF)
elseif(UNIX)
  list(APPEND EP_CMAKE_ARGS
    -DModule_vtkRenderingFreeTypeFontConfig:BOOL=ON
    -DVTK_USE_X:BOOL=ON)
endif()

if(PROJECTS_Python)
  list(APPEND EP_CMAKE_ARGS
    -DPYTHON_EXECUTABLE:PATH=${PYTHON_EXECUTABLE}
    -DPYTHON_INCLUDE_DIR:PATH=${PYTHON_INCLUDE_DIR}
    -DPYTHON_LIBRARY:FILEPATH=${PYTHON_LIBRARY})
endif()
if(PROJECTS_Qt)
  list(APPEND EP_CMAKE_ARGS -DQT_QMAKE_EXECUTABLE:FILEPATH=${QT_QMAKE_EXECUTABLE})
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
  GIT_TAG v7.0.0
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
