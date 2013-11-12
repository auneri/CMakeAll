cmake_minimum_required(VERSION 2.8.7)

find_package(CmakeTools REQUIRED
  HINTS "${CMAKE_CURRENT_LIST_DIR}/../../")

cmt_add_projects(
  ProjectA ProjectB ProjectC
  PREFIX "${CMT_SOURCE_DIR}/Testing/"
  SUFFIX ".cmake")

set(TESTING_ProjectA OFF CACHE BOOL "" FORCE)
set(TESTING_ProjectB OFF CACHE BOOL "" FORCE)
set(TESTING_ProjectC ON CACHE BOOL "" FORCE)

cmt_configure_projects(RESOLVE_DEPENDENCIES)
