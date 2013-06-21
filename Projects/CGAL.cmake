# Author: Ali Uneri
# Date: 2011-12-11

set(EP_URL http://cs.jhu.edu/istar/files/CGAL-3.9.zip)
set(EP_OPTION_DESCRIPTION "Computational Geometry Algorithms Library")

list(APPEND EP_LIBRARYPATH @BINARY_DIR@/lib)

cmt_end_definition()
# -----------------------------------------------------------------------------

set(EP_URL_MD5 2584ebc298afd4e7ff461bd471ca19fa)
set(EP_CMAKE_ARGS
  -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
  -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
  -DWITH_CGAL_Qt3:BOOL=OFF
  -DWITH_CGAL_Qt4:BOOL=OFF)

ExternalProject_Add(${EP_NAME}
  # download
  URL ${EP_URL}
  URL_MD5 ${EP_URL_MD5}
  # patch
  # update
  UPDATE_COMMAND ""
  # configure
  SOURCE_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}
  CMAKE_ARGS ${EP_CMAKE_ARGS}
  # build
  BINARY_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}-build
  # install
  INSTALL_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}-install
  # test
  )
