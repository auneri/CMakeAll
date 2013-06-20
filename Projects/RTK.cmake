# Author: Ali Uneri
# Date: 2012-08-31

set(EP_REQUIRED_PROJECTS Git ITK Patch)
set(EP_URL git://github.com/SimonRit/RTK.git)
set(EP_PATCH ${CMAKE_CURRENT_LIST_DIR}/Patches/${EP_NAME}.patch)
set(EP_OPTION_DESCRIPTION "Reconstruction Toolkit")

cmt_end_definition()
# -----------------------------------------------------------------------------

set(EP_REVISION 4d2e4685ece7808ed1b24922e910c829a99144e3)
set(EP_CMAKE_ARGS
  -DBUILD_APPLICATIONS:BOOL=OFF
  -DBUILD_EXAMPLES:BOOL=OFF
  -DBUILD_TESTING:BOOL=OFF
  -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
  -DITK_DIR:PATH=${PROJECT_BINARY_DIR}/ITK-build)

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
