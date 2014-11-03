# CMakeAll [![Build Status](https://travis-ci.org/auneri/CMakeAll.svg?branch=develop)](https://travis-ci.org/auneri/CMakeAll)
A solution built on [CMake](http://cmake.org/) and its *ExternalProject* module to provide explicit and extensible management of dependencies.


## Basic Example

~~~{.cmake}
cmake_minimum_required(VERSION 2.8.7)
project(BasicExample)

find_package(CMakeAll 1.0 REQUIRED)

cma_add_projects(
  "/source/dir/ProjectA.cmake"
  "/source/dir/ProjectB.cmake")

cma_configure_projects()
~~~
where `ProjectN.cmake` is referred to as a *project definition*.


## Project Definition

An example definition for ProjectA may be as follows.

~~~{.cmake}
set(EP_REQUIRED_PROJECTS ProjectB)
set(EP_URL "git://github.com/auneri/ProjectA.git")
set(EP_OPTION_NAME USE_ProjectA)

cma_list(APPEND EP_REQUIRED_PROJECTS Python IF USE_Python)
cma_envvar(PYTHONPATH APPEND "@SOURCE_DIR@" IF USE_Python)

cma_end_definition()

ExternalProject_Add(${EP_NAME}
  DEPENDS ${EP_REQUIRED_PROJECTS}
  GIT_REPOSITORY ${EP_URL}
  GIT_TAG "v1.0"
  SOURCE_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}
  CMAKE_ARGS -DBUILD_PYTHON_BINDINGS:BOOL=${USE_Python}
             -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
  BINARY_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}-build
  INSTALL_COMMAND "")
~~~

Variables listed below can be used to define a project, and should be set prior to calling `cma_end_definition`.

~~~{.cmake}
set(EP_NAME "${FILENAME}")    # project name
set(EP_REQUIRED_PROJECTS "")  # list of required projects
set(EP_REQUIRED_OPTIONS "")   # list of required options
set(EP_URL)                   # URL(s) of remote location to be verified
set(EP_PATCH "")              # patch file to apply

set(EP_OPTION_NAME "${DIRNAME}_${EP_NAME}")  # project CMake option
set(EP_OPTION_DEFAULT OFF)                   # default value of option
set(EP_OPTION_DEPENDENT OFF)                 # hide option until requirements are met
set(EP_OPTION_DESCRIPTION "")                # option description
set(EP_OPTION_ADVANCED OFF)                  # mark option as advanced
~~~


## Launcher

Each project may define its own environment variables using `cma_envvar`.

~~~{.cmake}
cma_envvar(PATH PREPEND @BINARY_DIR@/@LIBDIR@/@INTDIR@)

# variables that expand at build-time
set(INTDIR "@INTDIR@")
set(LIBDIR "@LIBDIR@")
set(SOURCE_DIR "@SOURCE_DIR@")
set(BINARY_DIR "@BINARY_DIR@")
set(INSTALL_DIR "@INSTALL_DIR@")
~~~

which are then used to configure a cross-platform launcher script that can be used as follows.

~~~bash
cmake -P /binary/dir/BasicExample.cmake
~~~


## Advanced Example

~~~{.cmake}
cmake_minimum_required(VERSION 2.8.7)
project(AdvancedExample)

find_package(CMakeAll 1.0 REQUIRED)

cma_add_projects(
  ProjectA ProjectB ProjectC
  PREFIX "${CMA_PROJECTS_DIR}/"
  SUFFIX ".cmake")

cma_configure_projects()
cma_configure_launcher()

cma_print_projects()
~~~


## Obtaining
**Option 1.** Standard method where CMake will request the path to your local copy.

~~~{.cmake}
find_package(CMakeAll 1.0 REQUIRED)
~~~

**Option 2.** Using [FindCMakeAll.cmake](https://github.com/auneri/CMakeAll/blob/develop/CMake/FindCMakeAll.cmake) where the project is cloned from GitHub. If version number is not specified master branch is cloned, and updated with each configure.

~~~{.cmake}
list(APPEND CMAKE_MODULE_PATH "/path/to/FindCMakeAll.cmake")
find_package(CMakeAll 1.0 REQUIRED)
~~~
