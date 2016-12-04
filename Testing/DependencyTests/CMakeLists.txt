cmake_minimum_required(VERSION 2.8.12)

project(DependencyTests NONE)

find_package(CMakeAll REQUIRED
  HINTS "${CMAKE_CURRENT_LIST_DIR}/../../")

cma_add_projects(
  ProjectA ProjectB ProjectC
  PREFIX "${CMA_SOURCE_DIR}/Testing/"
  SUFFIX ".cmake")

set(TESTING_ProjectA OFF CACHE BOOL "" FORCE)
set(TESTING_ProjectB OFF CACHE BOOL "" FORCE)
set(TESTING_ProjectC ON CACHE BOOL "" FORCE)

cma_configure_projects()
