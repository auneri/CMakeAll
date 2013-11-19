# Author: Ali Uneri
# Date: 2012-10-28

set(EP_REQUIRED_PROJECTS Git)
set(EP_URL git://github.com/commontk/zlib.git)

cma_end_definition()
# -----------------------------------------------------------------------------

set(EP_REVISION 66a753054b356da85e1838a081aa94287226823e)
set(EP_CMAKE_ARGS
  -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
  -DZLIB_MANGLE_PREFIX:STRING=cma_
  -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>)

ExternalProject_Add(${EP_NAME}
  DEPENDS ${EP_REQUIRED_PROJECTS}
  # download
  GIT_REPOSITORY ${EP_URL}
  GIT_TAG ${EP_REVISION}
  # patch
  # update
  # configure
  SOURCE_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}
  CMAKE_ARGS ${EP_CMAKE_ARGS}
  # build
  BINARY_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}-build
  # install
  INSTALL_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}-install
  # test
  )

set(CMA_ZLIB_ROOT "${PROJECT_BINARY_DIR}/${EP_NAME}-install" CACHE INTERNAL "")
set(CMA_ZLIB_INCLUDE_DIR "${CMA_ZLIB_ROOT}/include" CACHE INTERNAL "")
if(WIN32)
  set(CMA_ZLIB_LIBRARY "${CMA_ZLIB_ROOT}/lib/zlib.lib" CACHE INTERNAL "")
else()
  set(CMA_ZLIB_LIBRARY "${CMA_ZLIB_ROOT}/lib/libzlib.a" CACHE INTERNAL "")
endif()
