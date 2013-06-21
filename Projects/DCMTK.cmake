# Author: Ali Uneri
# Date: 2012-10-28

set(EP_REQUIRED_PROJECTS Git)
set(EP_URL git://git.dcmtk.org/dcmtk.git)
set(EP_OPTION_DESCRIPTION "DICOM Toolkit")

cmt_end_definition()
# -----------------------------------------------------------------------------

set(EP_REVISION DCMTK-3.6.1_20121102)
set(EP_CMAKE_ARGS
  -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
  -DDCMTK_WITH_DOXYGEN:BOOL=OFF
  -DDCMTK_WITH_ICONV:BOOL=OFF
  -DDCMTK_WITH_OPENSSL:BOOL=OFF
  -DDCMTK_WITH_PNG:BOOL=OFF
  -DDCMTK_WITH_TIFF:BOOL=OFF
  -DDCMTK_WITH_XML:BOOL=OFF
  -DDCMTK_WITH_ZLIB:BOOL=OFF)

if(PROJECTS_Slicer)
  list(APPEND EP_CMAKE_ARGS -DBUILD_SHARED_LIBS:BOOL=ON)
endif()

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
