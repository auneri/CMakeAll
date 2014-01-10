set(EP_REQUIRED_PROJECTS Git)
set(EP_URL git://vtk.org/VTK.git)
set(EP_OPTION_DESCRIPTION "Visualization Toolkit")

list(APPEND EP_LIBRARYPATH @BINARY_DIR@/bin/@INTDIR@)
list(APPEND EP_PYTHONPATH
  @BINARY_DIR@/bin/@INTDIR@
  @BINARY_DIR@/Wrapping/Python)

if(PROJECTS_Python)
  list(APPEND EP_REQUIRED_PROJECTS Patch Python)
  set(EP_PATCH ${CMAKE_CURRENT_LIST_DIR}/Patches/${EP_NAME}.patch)
endif()
if(PROJECTS_Qt)
  list(APPEND EP_REQUIRED_PROJECTS Qt)
endif()
if(PROJECTS_zlib)
  list(APPEND EP_REQUIRED_PROJECTS zlib)
endif()

cma_end_definition()
# -----------------------------------------------------------------------------

cmake_dependent_option(${EP_OPTION_NAME}_TDx "Support for 3DConnexion devices" OFF ${EP_OPTION_NAME} OFF)

set(EP_CMAKE_ARGS
  -DBUILD_SHARED_LIBS:BOOL=${PROJECTS_Python}
  -DBUILD_TESTING:BOOL=OFF
  -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
  -DCMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
  -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
  -DVTK_DEBUG_LEAKS:BOOL=ON
  -DVTK_LEGACY_REMOVE:BOOL=ON
  -DVTK_USE_DISPLAY:BOOL=OFF
  -DVTK_USE_PARALLEL:BOOL=ON
  -DVTK_USE_QT:BOOL=${PROJECTS_Qt}
  -DVTK_USE_SYSTEM_ZLIB:BOOL=${PROJECTS_zlib}
  -DVTK_USE_TDX:BOOL=${${EP_OPTION_NAME}_TDx}
  -DVTK_USE_TK:BOOL=OFF
  -DVTK_WRAP_PYTHON:BOOL=${PROJECTS_Python})

if(PROJECTS_Python)
  list(APPEND EP_CMAKE_ARGS
    -DPYTHON_EXECUTABLE:PATH=${CMA_PYTHON_EXECUTABLE}
    -DPYTHON_INCLUDE_DIR:PATH=${CMA_PYTHON_INCLUDE_DIR}
    -DPYTHON_LIBRARY:FILEPATH=${CMA_PYTHON_LIBRARY})
endif()
if(PROJECTS_Qt)
  list(APPEND EP_CMAKE_ARGS
    -DQT_QMAKE_EXECUTABLE:FILEPATH=${CMA_QT_QMAKE_EXECUTABLE}
    -DVTK_USE_QVTK_QTOPENGL:BOOL=ON)
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
  GIT_TAG v5.10.1
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
