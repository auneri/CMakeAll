set(EP_REQUIRED_PROJECTS Python)
set(EP_OPTION_DESCRIPTION "Simplified Wrapper and Interface Generator")

set(EP_VERSION 3.0.2)
if(WIN32)
  set(EP_URL "http://sourceforge.net/projects/swig/files/swigwin/swigwin-${EP_VERSION}/swigwin-${EP_VERSION}.zip/download")
  set(EP_URL_MD5 3f18de4fc09ab9abb0d3be37c11fbc8f)
elseif(UNIX)
  set(PCRE_VERSION 8.35)
  set(EP_URL "http://sourceforge.net/projects/pcre/files/pcre/${PCRE_VERSION}/pcre-${PCRE_VERSION}.tar.gz/download"
             "http://sourceforge.net/projects/swig/files/swig/swig-${EP_VERSION}/swig-${EP_VERSION}.tar.gz/download")
  set(EP_URL_MD5 ed58bcbe54d3b1d59e9f5415ef45ce1c
                 62f9b0d010cef36a13a010dc530d0d41)
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
  ExternalProject_add(PCRE
    DEPENDS ${EP_REQUIRED_PROJECTS}
    # download
    URL ${URL}
    URL_MD5 ${URL_MD5}
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
  ExternalProject_add(${EP_NAME}
    DEPENDS PCRE
    # download
    URL ${URL}
    URL_MD5 ${URL_MD5}
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

set(CMA_SWIG_DIR "${SWIG_DIR}" CACHE INTERNAL "")
set(CMA_SWIG_EXECUTABLE "${SWIG_EXECUTABLE}" CACHE INTERNAL "")
set(CMA_SWIG_VERSION "${EP_VERSION}" CACHE INTERNAL "")
