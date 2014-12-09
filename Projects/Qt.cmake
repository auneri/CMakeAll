cma_end_definition()
# -----------------------------------------------------------------------------

find_package(Qt 4.8.6 REQUIRED)

ExternalProject_Add(${EP_NAME}
  DOWNLOAD_COMMAND ""
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND "")

set(QT_QMAKE_EXECUTABLE "${QT_QMAKE_EXECUTABLE}" CACHE INTERNAL "")
