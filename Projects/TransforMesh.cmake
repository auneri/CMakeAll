# Author: Ali Uneri
# Date: 2011-11-08

set(EP_REQUIRED_PROJECTS CGAL Patch Subversion)
set(EP_URL svn://scm.gforge.inria.fr/svn/mvviewer)
set(EP_PATCH ${CMAKE_CURRENT_LIST_DIR}/Patches/${EP_NAME}.patch)

cmt_end_definition()
# -----------------------------------------------------------------------------

set(EP_REVISION 257)
set(EP_CMAKE_ARGS
  -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
  -DCGAL_DIR:PATH=${PROJECT_BINARY_DIR}/CGAL-install/lib/CGAL)

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
