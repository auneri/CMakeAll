# Author: Ali Uneri
# Date: 2012-09-18

set(EP_REQUIRED_PROJECTS Python Subversion)
set(EP_REQUIRED_OPTIONS UNIX)
set(EP_URL svn://svn.code.sf.net/p/cmusphinx/code/tags/sphinxbase-0.8
           svn://svn.code.sf.net/p/cmusphinx/code/tags/pocketsphinx-0.8)
set(EP_OPTION_DESCRIPTION "CMU Sphinx")

list(APPEND EP_PYTHONPATH
  ${PROJECT_BINARY_DIR}/SphinxBase-install/lib/python2.7/site-packages
  ${PROJECT_BINARY_DIR}/PocketSphinx-install/lib/python2.7/site-packages)

cma_end_definition()
# -----------------------------------------------------------------------------

list(GET EP_URL 0 URL)
ExternalProject_Add(SphinxBase
  DEPENDS ${EP_REQUIRED_PROJECTS}
  # download
  SVN_REPOSITORY ${URL}
  # patch
  # update
  # configure
  SOURCE_DIR ${PROJECT_BINARY_DIR}/SphinxBase
  CONFIGURE_COMMAND
    ./autogen.sh --help &&
    ./autogen.sh --help &&
    ./configure
      --prefix=${PROJECT_BINARY_DIR}/SphinxBase-install
  # build
  BUILD_IN_SOURCE 1
  # install
  INSTALL_DIR ${PROJECT_BINARY_DIR}/SphinxBase-install
  # test
  )

list(GET EP_URL 1 URL)
ExternalProject_Add(PocketSphinx
  DEPENDS SphinxBase
  # download
  SVN_REPOSITORY ${URL}
  # patch
  # update
  # configure
  SOURCE_DIR ${PROJECT_BINARY_DIR}/PocketSphinx
  CONFIGURE_COMMAND
    ./autogen.sh --help &&
    ./autogen.sh --help &&
    ./configure
      --with-sphinxbase=${PROJECT_BINARY_DIR}/SphinxBase
      --with-sphinxbase-build=${PROJECT_BINARY_DIR}/SphinxBase
      --prefix=${PROJECT_BINARY_DIR}/PocketSphinx-install
  # build
  BUILD_IN_SOURCE 1
  # install
  INSTALL_DIR ${PROJECT_BINARY_DIR}/PocketSphinx-install
  # test
  )

ExternalProject_Add(${EP_NAME}
  DEPENDS PocketSphinx
  DOWNLOAD_COMMAND ""
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND "")
