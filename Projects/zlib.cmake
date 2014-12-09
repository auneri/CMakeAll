set(EP_REQUIRED_PROJECTS Git)
set(EP_URL "git://github.com/commontk/zlib.git")

cma_end_definition()
# -----------------------------------------------------------------------------

set(EP_CMAKE_ARGS
  -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
  -DCMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
  -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
  -DZLIB_MANGLE_PREFIX:STRING=cma_
  -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>)

ExternalProject_Add(${EP_NAME}
  DEPENDS ${EP_REQUIRED_PROJECTS}
  # download
  GIT_REPOSITORY ${EP_URL}
  GIT_TAG 66a753054b356da85e1838a081aa94287226823e
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

set(ZLIB_ROOT "${PROJECT_BINARY_DIR}/${EP_NAME}-install" CACHE INTERNAL "")
set(ZLIB_INCLUDE_DIR "${ZLIB_ROOT}/include" CACHE INTERNAL "")
if(WIN32)
  set(ZLIB_LIBRARY "${ZLIB_ROOT}/lib/zlib.lib" CACHE INTERNAL "")
elseif(UNIX)
  set(ZLIB_LIBRARY "${ZLIB_ROOT}/lib/libzlib.a" CACHE INTERNAL "")
else()
  message(FATAL_ERROR "Platform is not supported.")
endif()
