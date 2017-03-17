# CMakeAll
A solution built on [CMake](https://cmake.org) and its [ExternalProject module](https://cmake.org/cmake/help/latest/module/ExternalProject.html) to provide explicit and extensible management of dependencies.

[![release](https://img.shields.io/github/release/auneri/CMakeAll.svg)](https://github.com/auneri/CMakeAll/releases)
[![license](https://img.shields.io/github/license/auneri/CMakeAll.svg)](https://github.com/auneri/CMakeAll/blob/master/LICENSE.md)
[![build](https://img.shields.io/travis/auneri/CMakeAll.svg)](https://travis-ci.org/auneri/CMakeAll)
[![issues](https://img.shields.io/github/issues/auneri/CMakeAll.svg)](https://github.com/auneri/CMakeAll/issues)


## Getting Started

```cmake
cmake_minimum_required(VERSION 2.8.7)
project(HelloWorld)

find_package(CMakeAll 1.1 REQUIRED)

cma_add_projects("/source/dir/ProjectA.cmake")

cma_add_projects(ProjectB ProjectC ProjectD
  PREFIX "${PROJECT_SOURCE_DIR}/"
  SUFFIX ".cmake")

cma_configure_projects()
cma_configure_launcher()
cma_print_projects()
```

where a simple *project definition script* for `ProjectA` may contain:

```cmake
set(EP_REQUIRED_PROJECTS ProjectB)
set(EP_URL "https://github.com/organization/ProjectA.git")

cma_end_definition()

ExternalProject_Add(${EP_NAME}
  DEPENDS ${EP_REQUIRED_PROJECTS}
  GIT_REPOSITORY ${EP_URL}
  GIT_TAG v1.0
  SOURCE_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}
  CMAKE_ARGS -DCMAKE_BUILD_TYPE:STRING=Relase
  BINARY_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}-build
  INSTALL_COMMAND "")
```

Variables listed below can be used to define a project, and should be set prior to calling `cma_end_definition`.

```cmake
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
```

Each project may define its own environment variables using `cma_envvar`.

```cmake
cma_envvar(PATH PREPEND @BINARY_DIR@/@LIBDIR@/@INTDIR@)

# variables that expand at build-time
set(INTDIR "@INTDIR@")
set(LIBDIR "@LIBDIR@")
set(SOURCE_DIR "@SOURCE_DIR@")
set(BINARY_DIR "@BINARY_DIR@")
set(INSTALL_DIR "@INSTALL_DIR@")
```

which are then used to configure a *launcher script* that may be used as:

```sh
cmake -P /binary/dir/HelloWorld.cmake
```


## Obtaining
**Option 1.** Standard method where CMake will request the path to your local copy.

```cmake
find_package(CMakeAll 1.1 REQUIRED)
```

**Option 2.** Using [FindCMakeAll.cmake](https://github.com/auneri/CMakeAll/blob/v1.1/CMake/FindCMakeAll.cmake) where the project is automatically cloned from GitHub. If version number is not specified master branch is cloned and updated with each *configure*.

```cmake
list(APPEND CMAKE_MODULE_PATH "/path/to/FindCMakeAll.cmake")
find_package(CMakeAll 1.1 REQUIRED)
```
