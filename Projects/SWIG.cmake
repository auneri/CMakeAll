set(EP_REQUIRED_PROJECTS Python)
set(EP_OPTION_DESCRIPTION "Simplified Wrapper and Interface Generator")
set(EP_VERSION 3.0.8)

if(WIN32)
  set(EP_URL "http://downloads.sourceforge.net/project/swig/swigwin/swigwin-${EP_VERSION}/swigwin-${EP_VERSION}.zip")
  set(EP_URL_MD5 07bc00f7511b7d57516c50f59d705efa)
elseif(UNIX)
  set(PCRE_VERSION 8.37)
  set(EP_URL "http://downloads.sourceforge.net/project/pcre/pcre/${PCRE_VERSION}/pcre-${PCRE_VERSION}.tar.gz"
             "http://downloads.sourceforge.net/project/swig/swig/swig-${EP_VERSION}/swig-${EP_VERSION}.tar.gz")
  set(EP_URL_MD5 6e0cc6d1bdac7a4308151f9b3571b86e
                 c96a1d5ecb13d38604d7e92148c73c97)
else()
  message(FATAL_ERROR "Platform is not supported.")
endif()

cma_end_definition()
# -----------------------------------------------------------------------------

if(WIN32)
  ExternalProject_Add(${EP_NAME}
    DEPENDS ${EP_REQUIRED_PROJECTS}
    URL ${EP_URL}
    URL_MD5 ${EP_URL_MD5}
    TIMEOUT 300
    UPDATE_COMMAND ""
    SOURCE_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}-install
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND "")

  set(SWIG_DIR "${PROJECT_BINARY_DIR}/${EP_NAME}-install")
  set(SWIG_EXECUTABLE "${PROJECT_BINARY_DIR}/${EP_NAME}-install/swig.exe")
elseif(UNIX)
  list(GET EP_URL 0 URL)
  list(GET EP_URL_MD5 0 URL_MD5)
  ExternalProject_Add(PCRE
    DEPENDS ${EP_REQUIRED_PROJECTS}
    URL ${URL}
    URL_MD5 ${URL_MD5}
    TIMEOUT 300
    UPDATE_COMMAND ""
    SOURCE_DIR ${PROJECT_BINARY_DIR}/PCRE
    CONFIGURE_COMMAND <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --disable-shared
    BINARY_DIR ${PROJECT_BINARY_DIR}/PCRE-build
    INSTALL_DIR ${PROJECT_BINARY_DIR}/PCRE-install)

  list(GET EP_URL 1 URL)
  list(GET EP_URL_MD5 1 URL_MD5)
  ExternalProject_Add(${EP_NAME}
    DEPENDS PCRE
    URL ${URL}
    URL_MD5 ${URL_MD5}
    TIMEOUT 300
    UPDATE_COMMAND ""
    SOURCE_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}
    CONFIGURE_COMMAND <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --with-pcre-prefix=${PROJECT_BINARY_DIR}/PCRE-install
    BINARY_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}-build
    INSTALL_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}-install)

  set(SWIG_DIR "${PROJECT_BINARY_DIR}/${EP_NAME}-install/share/swig/${EP_VERSION}")
  set(SWIG_EXECUTABLE "${PROJECT_BINARY_DIR}/${EP_NAME}-install/bin/swig")
endif()

set(SWIG_DIR "${SWIG_DIR}" CACHE INTERNAL "")
set(SWIG_EXECUTABLE "${SWIG_EXECUTABLE}" CACHE INTERNAL "")
set(SWIG_VERSION "${EP_VERSION}" CACHE INTERNAL "")
