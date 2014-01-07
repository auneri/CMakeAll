cma_end_definition()
# -----------------------------------------------------------------------------

find_package(Qt 4.7.4 REQUIRED)

set(CMA_QT_VERSION "${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}" CACHE INTERNAL "")
set(CMA_QT_QMAKE_EXECUTABLE "${QT_QMAKE_EXECUTABLE}" CACHE INTERNAL "")

ExternalProject_Add(${EP_NAME}
  DOWNLOAD_COMMAND ""
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND "")
