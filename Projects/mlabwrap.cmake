# Author: Ali Uneri
# Date: 2012-06-09

set(EP_REQUIRED_PROJECTS Git MATLAB Python)
set(EP_URL git://github.com/auneri/mlabwrap.git)

list(APPEND EP_LIBRARYPATH @INSTALL_DIR@/lib/python)
list(APPEND EP_PYTHONPATH @INSTALL_DIR@/lib/python)

cma_end_definition()
# -----------------------------------------------------------------------------

set(EP_REVISION c9105fe06e9bcdbdf9600087f1c683866cead244)
set(EP_CMAKE_ARGS)

file(TO_NATIVE_PATH ${PROJECT_BINARY_DIR} PROJECT_BINARY_NATIVE_DIR)

ExternalProject_Add(${EP_NAME}
  DEPENDS ${EP_REQUIRED_PROJECTS}
  # download
  GIT_REPOSITORY ${EP_URL}
  GIT_TAG ${EP_REVISION}
  # patch
  # update
  # configure
  SOURCE_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}
  CONFIGURE_COMMAND ""
  # build
  BUILD_COMMAND ${CMA_PYTHON_EXECUTABLE} ./setup.py
    build --build-base=${PROJECT_BINARY_NATIVE_DIR}/${EP_NAME}-build
    install --home=${PROJECT_BINARY_NATIVE_DIR}/${EP_NAME}-install
  BUILD_IN_SOURCE 1
  # install
  INSTALL_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}-install
  INSTALL_COMMAND ""
  # test
  )
