# Author: Ali Uneri
# Date: 2011-07-25

set(CMT_SLICER_VERSION 4.2 CACHE INTERNAL "")

set(EP_REQUIRED_PROJECTS ITK Patch Python PythonTools Qt Subversion VTK)
set(EP_URL http://svn.slicer.org/Slicer4/trunk)
set(EP_PATCH ${CMAKE_CURRENT_LIST_DIR}/Patches/${EP_NAME}.patch)
set(EP_OPTION_DESCRIPTION "3D Slicer")

list(APPEND EP_LIBRARYPATH
  @BINARY_DIR@/${EP_NAME}-build/bin/@INTDIR@
  @BINARY_DIR@/${EP_NAME}-build/lib/Slicer-${CMT_SLICER_VERSION}/cli-modules/@INTDIR@
  @BINARY_DIR@/${EP_NAME}-build/lib/Slicer-${CMT_SLICER_VERSION}/qt-loadable-modules/@INTDIR@
  @BINARY_DIR@/CTK-build/CTK-build/bin/@INTDIR@
  @BINARY_DIR@/CTK-build/PythonQt-build/@INTDIR@
  @BINARY_DIR@/CTK-build/QtTesting-build/@INTDIR@
  @BINARY_DIR@/LibArchive-install/@LIBDIR@
  @BINARY_DIR@/SlicerExecutionModel-build/ModuleDescriptionParser/bin/@INTDIR@
  @BINARY_DIR@/teem-build/bin/@INTDIR@)
list(APPEND EP_PYTHONPATH
  @BINARY_DIR@/${EP_NAME}-build/bin/@INTDIR@
  @BINARY_DIR@/${EP_NAME}-build/bin/Python
  @BINARY_DIR@/${EP_NAME}-build/lib/Slicer-${CMT_SLICER_VERSION}/qt-loadable-modules/@INTDIR@
  @BINARY_DIR@/${EP_NAME}-build/bin/lib/Slicer-${CMT_SLICER_VERSION}/qt-loadable-modules/Python)

if(${EP_OPTION_NAME}_OpenIGTLink)
  list(APPEND EP_LIBRARYPATH @BINARY_DIR@/OpenIGTLink-build/bin/@INTDIR@)
endif()

cmt_end_definition()
# -----------------------------------------------------------------------------

cmake_dependent_option(${EP_OPTION_NAME}_CLI_MODULES "Build Slicer's CLI Modules" OFF ${EP_OPTION_NAME} OFF)
cmake_dependent_option(${EP_OPTION_NAME}_OpenIGTLink "Support for OpenIGTLink" OFF ${EP_OPTION_NAME} OFF)

# http://www.slicer.org/slicerWiki/index.php/Release_Details
set(EP_REVISION 21513)

set(EP_CMAKE_ARGS
  -DBUILD_TESTING:BOOL=OFF
  -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
  -DCMT_CMAKE_DIR:PATH=${CMT_CMAKE_DIR}
  -DCMT_CTK_PATCH:FILEPATH=${CMAKE_CURRENT_LIST_DIR}/Patches/CTK.patch
  -DCMT_GIT_EXECUTABLE:FILEPATH=${CMT_GIT_EXECUTABLE}
  -DCMT_PATCH_EXECUTABLE:FILEPATH=${CMT_PATCH_EXECUTABLE}
  -DCMT_PYTHON_EXECUTABLE:FILEPATH=${CMT_PYTHON_EXECUTABLE}
  -DCMT_PYTHON_INCLUDE_DIR:PATH=${CMT_PYTHON_INCLUDE_DIR}
  -DCMT_PYTHON_LIBRARY:FILEPATH=${CMT_PYTHON_LIBRARY}
  -DCMT_PythonQt_PATCH:FILEPATH=${CMAKE_CURRENT_LIST_DIR}/Patches/PythonQt.patch
  -DITK_DIR:PATH=${PROJECT_BINARY_DIR}/ITK-build
  -DITK_VERSION_MAJOR:STRING=4
  -DQT_QMAKE_EXECUTABLE:PATH=${CMT_QT_QMAKE_EXECUTABLE}
  -DSlicer_BUILD_ChangeTrackerPy:BOOL=OFF
  -DSlicer_BUILD_CLI:BOOL=${${EP_OPTION_NAME}_CLI_MODULES}
  -DSlicer_BUILD_EMSegment:BOOL=OFF
  -DSlicer_BUILD_LEGACY_CLI:BOOL=OFF
  -DSlicer_REQUIRED_QT_VERSION:STRING=${CMT_QT_VERSION}
  -DSlicer_USE_OpenIGTLink:BOOL=${${EP_OPTION_NAME}_OpenIGTLink}
  -DSlicer_USE_PYTHONQT_WITH_TCL:BOOL=OFF
  -DVTK_DIR:PATH=${PROJECT_BINARY_DIR}/VTK-build)

if(UNIX AND NOT CMAKE_SIZEOF_VOID_P EQUAL 8)
  list(APPEND EP_CMAKE_ARGS -DSlicer_USE_CTKAPPLAUNCHER:BOOL=OFF)
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
