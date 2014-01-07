set(EP_REQUIRED_PROJECTS Python)
set(EP_OPTION_DESCRIPTION "Simplified Wrapper and Interface Generator")

set(EP_VERSION 2.0.11)
if(WIN32)
  set(EP_URL http://sourceforge.net/projects/swig/files/swigwin/swigwin-${EP_VERSION}/swigwin-${EP_VERSION}.zip/download)
  set(EP_URL_MD5 b902bac6500eb3ea8c6e62c4e6b3832c)
else()
  set(PCRE_VERSION 8.33)
  set(EP_URL http://sourceforge.net/projects/pcre/files/pcre/${PCRE_VERSION}/pcre-${PCRE_VERSION}.tar.gz/download
             http://sourceforge.net/projects/swig/files/swig/swig-${EP_VERSION}/swig-${EP_VERSION}.tar.gz/download)
  set(EP_URL_MD5 94854c93dcc881edd37904bb6ef49ebc
                 291ba57c0acd218da0b0916c280dcbae)
endif()

cma_end_definition()
# -----------------------------------------------------------------------------

if(WIN32)
  set(SWIG_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}-install)
  set(SWIG_EXECUTABLE ${PROJECT_BINARY_DIR}/${EP_NAME}-install/swig.exe)

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
else()
  set(SWIG_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}-install/share/swig/${EP_VERSION})
  set(SWIG_EXECUTABLE ${PROJECT_BINARY_DIR}/${EP_NAME}-install/bin/swig)

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
    CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/PCRE/configure
      --prefix=${PROJECT_BINARY_DIR}/PCRE-install
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
    CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/${EP_NAME}/configure
      --prefix=${PROJECT_BINARY_DIR}/${EP_NAME}-install
      --with-pcre-prefix=${PROJECT_BINARY_DIR}/PCRE-install
    # build
    BINARY_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}-build
    # install
    INSTALL_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}-install
    )
endif()

set(CMA_SWIG_DIR "${SWIG_DIR}" CACHE INTERNAL "")
set(CMA_SWIG_EXECUTABLE "${SWIG_EXECUTABLE}" CACHE INTERNAL "")
set(CMA_SWIG_VERSION "${EP_VERSION}" CACHE INTERNAL "")
