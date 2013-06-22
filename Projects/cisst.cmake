# Author: Ali Uneri
# Date: 2011-07-25

set(EP_REQUIRED_PROJECTS Patch Qt Subversion)
set(EP_URL https://svn.lcsr.jhu.edu/cisst/trunk)
set(EP_PATCH ${CMAKE_CURRENT_LIST_DIR}/Patches/${EP_NAME}.patch)
set(EP_OPTION_DESCRIPTION "Computer-Integrated Surgical Systems and Technology")

list(APPEND EP_PATH
  @BINARY_DIR@/cisst/bin/@INTDIR@
  @BINARY_DIR@/saw/bin/@INTDIR@)
list(APPEND EP_LIBRARYPATH
  @BINARY_DIR@/cisst/lib/@INTDIR@
  @BINARY_DIR@/saw/lib/@INTDIR@)

if(PROJECTS_OpenCV)
  list(APPEND EP_REQUIRED_PROJECTS OpenCV)
endif()
if(PROJECTS_Slicer_OpenIGTLink)
  list(APPEND EP_REQUIRED_PROJECTS Slicer)
endif()
if(PROJECTS_SWIG)
  list(APPEND EP_REQUIRED_PROJECTS SWIG)
  list(APPEND EP_PYTHONPATH @BINARY_DIR@/cisst/lib/@INTDIR@)
endif()

cmt_end_definition()
# -----------------------------------------------------------------------------

if(WIN32)
  cmake_dependent_option(${EP_OPTION_NAME}_MicronTracker "Support for Claron MicronTracker" OFF ${EP_OPTION_NAME} OFF)
endif()

set(EP_REVISION 4092)
set(EP_CMAKE_ARGS
  -DCISST_BUILD_APPLICATIONS:BOOL=OFF
  -DCISST_BUILD_SHARED_LIBS:BOOL=ON
  -DCISST_BUILD_TESTS:BOOL=OFF
  -DCISST_cisstCommon:BOOL=ON
  -DCISST_cisstCommonXML:BOOL=ON
  -DCISST_cisstMultiTask:BOOL=ON
  -DCISST_cisstNumerical:BOOL=ON
  -DCISST_cisstOSAbstraction:BOOL=ON
  -DCISST_cisstParameterTypes:BOOL=ON
  -DCISST_cisstRobot:BOOL=OFF
  -DCISST_cisstStereoVision:BOOL=ON
  -DCISST_cisstVector:BOOL=ON
  -DCISST_HAS_CISSTNETLIB:BOOL=OFF
  -DCISST_HAS_FLTK:BOOL=OFF
  -DCISST_HAS_OPENGL:BOOL=ON
  -DCISST_HAS_QT:BOOL=ON
  -DCISST_HAS_SWIG_PYTHON:BOOL=${PROJECTS_SWIG}
  -DCISST_MTS_HAS_ICE:BOOL=OFF
  -DCISST_SVL_HAS_CUDA:BOOL=OFF
  -DCISST_SVL_HAS_OPENCV:BOOL=OFF
  -DCISST_SVL_HAS_OPENCV2:BOOL=${PROJECTS_OpenCV}
  -DCISST_XML_LIB:STRING=QtXML
  -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
  -DQT_QMAKE_EXECUTABLE:FILEPATH=${CMT_QT_QMAKE_EXECUTABLE})

if(UNIX AND NOT APPLE)
  list(APPEND EP_CMAKE_ARGS -DCISST_SVL_HAS_X11:BOOL=ON)
else()
  list(APPEND EP_CMAKE_ARGS -DCISST_SVL_HAS_X11:BOOL=OFF)
endif()
if(PROJECTS_OpenCV)
  list(APPEND EP_CMAKE_ARGS
    -DOpenCV2_ROOT_DIR:PATH=${PROJECT_BINARY_DIR}/OpenCV-build)
endif()
if(PROJECTS_SWIG)
  list(APPEND EP_CMAKE_ARGS
    -DPYTHON_EXECUTABLE:FILEPATH=${CMT_PYTHON_EXECUTABLE}
    -DPYTHON_INCLUDE_DIR:PATH=${CMT_PYTHON_INCLUDE_DIR}
    -DPYTHON_LIBRARY:FILEPATH=${CMT_PYTHON_LIBRARY}
    -DPYTHON_NUMPY_INCLUDE_DIR:PATH=${PYTHON_NUMPY_INCLUDE_DIR}
    -DSWIG_DIR:PATH=${CMT_SWIG_DIR}
    -DSWIG_EXECUTABLE:FILEPATH=${CMT_SWIG_EXECUTABLE}
    -DSWIG_VERSION:STRING=${CMT_SWIG_VERSION})
endif()

set(EP_CMAKE_ARGS_RECONFIGURE
  -DCISST_BUILD_SAW:BOOL=ON
  -DSAW_BUILD_APPLICATIONS:BOOL=OFF
  -DSAW_BUILD_COMPONENTS:BOOL=ON
  -DSAW_3Dconnexion:BOOL=${PROJECTS_VTK_TDx}
  -DSAW_ClaronMicronTracker:BOOL=${${EP_OPTION_NAME}_MicronTracker}
  -DSAW_NDITracker:BOOL=ON
  -DSAW_OpenIGTLink:BOOL=${PROJECTS_Slicer_OpenIGTLink})

if(PROJECTS_Slicer_OpenIGTLink)
  list(APPEND EP_CMAKE_ARGS_RECONFIGURE
    -DOpenIGTLink_DIR:PATH=${PROJECT_BINARY_DIR}/Slicer-build/OpenIGTLink-build)
endif()

ExternalProject_Add(${EP_NAME}
  DEPENDS ${EP_REQUIRED_PROJECTS}
  # download
  SVN_REPOSITORY ${EP_URL}
  SVN_REVISION -r ${EP_REVISION}
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

ExternalProject_Add_Step(${EP_NAME} reconfigure
  COMMENT "Reconfiguring '${EP_NAME}'"
  COMMAND ${CMAKE_COMMAND} ${EP_CMAKE_ARGS_RECONFIGURE} <BINARY_DIR>
  DEPENDEES configure
  DEPENDERS build
  WORKING_DIRECTORY <BINARY_DIR>)
