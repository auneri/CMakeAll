set(EP_REQUIRED_PROJECTS Python)
set(EP_OPTION_DESCRIPTION "Simplified Wrapper and Interface Generator")

set(EP_VERSION 3.0.7)
if(WIN32)
  set(EP_URL "http://downloads.sourceforge.net/project/swig/swigwin/swigwin-${EP_VERSION}/swigwin-${EP_VERSION}.zip")
  set(EP_URL_MD5 d8b5a9ce49c819cc1bfc1e797b85ba7a)
elseif(UNIX)
  set(PCRE_VERSION 8.37)
  set(EP_URL "http://downloads.sourceforge.net/project/pcre/pcre/${PCRE_VERSION}/pcre-${PCRE_VERSION}.tar.gz"
             "http://downloads.sourceforge.net/project/swig/swig/swig-${EP_VERSION}/swig-${EP_VERSION}.tar.gz")
  set(EP_URL_MD5 6e0cc6d1bdac7a4308151f9b3571b86e
                 7fff46c84b8c630ede5b0f0827e3d90a)
else()
  message(FATAL_ERROR "Platform is not supported.")
endif()

cma_end_definition()
# -----------------------------------------------------------------------------

if(WIN32)
  ExternalProject_Add(${EP_NAME}
    DEPENDS ${EP_REQUIRED_PROJECTS}
    # download
    URL ${EP_URL}
    URL_MD5 ${EP_URL_MD5}
    TIMEOUT 60
    # patch
    # update
    UPDATE_COMMAND ""
    # configure
    SOURCE_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}-install
    CONFIGURE_COMMAND ""
    # build
    BUILD_COMMAND ""
    # install
    INSTALL_COMMAND ""
    # test
    )

  set(SWIG_DIR "${PROJECT_BINARY_DIR}/${EP_NAME}-install")
  set(SWIG_EXECUTABLE "${PROJECT_BINARY_DIR}/${EP_NAME}-install/swig.exe")
elseif(UNIX)
  list(GET EP_URL 0 URL)
  list(GET EP_URL_MD5 0 URL_MD5)
  ExternalProject_Add(PCRE
    DEPENDS ${EP_REQUIRED_PROJECTS}
    # download
    URL ${URL}
    URL_MD5 ${URL_MD5}
    TIMEOUT 60
    # patch
    # update
    UPDATE_COMMAND ""
    # configure
    SOURCE_DIR ${PROJECT_BINARY_DIR}/PCRE
    CONFIGURE_COMMAND <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --disable-shared
    # build
    BINARY_DIR ${PROJECT_BINARY_DIR}/PCRE-build
    # install
    INSTALL_DIR ${PROJECT_BINARY_DIR}/PCRE-install
    )

  list(GET EP_URL 1 URL)
  list(GET EP_URL_MD5 1 URL_MD5)
  ExternalProject_Add(${EP_NAME}
    DEPENDS PCRE
    # download
    URL ${URL}
    URL_MD5 ${URL_MD5}
    TIMEOUT 60
    # patch
    # update
    UPDATE_COMMAND ""
    # configure
    SOURCE_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}
    CONFIGURE_COMMAND <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --with-pcre-prefix=${PROJECT_BINARY_DIR}/PCRE-install
    # build
    BINARY_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}-build
    # install
    INSTALL_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}-install
    )

  set(SWIG_DIR "${PROJECT_BINARY_DIR}/${EP_NAME}-install/share/swig/${EP_VERSION}")
  set(SWIG_EXECUTABLE "${PROJECT_BINARY_DIR}/${EP_NAME}-install/bin/swig")
else()
  message(FATAL_ERROR "Platform is not supported.")
endif()

set(SWIG_DIR "${SWIG_DIR}" CACHE INTERNAL "")
set(SWIG_EXECUTABLE "${SWIG_EXECUTABLE}" CACHE INTERNAL "")
set(SWIG_VERSION "${EP_VERSION}" CACHE INTERNAL "")
