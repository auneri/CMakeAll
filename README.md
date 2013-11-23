# CMakeAll
A solution built on [CMake](http://cmake.org/) and its *ExternalProject* module to provide explicit and extensible management of dependencies.


## Obtaining
**Option 1.** Tell CMake the path to your local copy.
```cmake
find_package(CMakeAll 1.0 REQUIRED)
```

**Option 2.** Tell CMake to clone/checkout from GitHub.
```cmake
set(CMakeAll_DIR ${CMAKE_CURRENT_BINARY_DIR}/CMakeAll)
find_program(GIT NAMES git)
if(NOT EXISTS ${CMakeAll_DIR})
  execute_process(COMMAND ${GIT} clone https://github.com/auneri/CMakeAll.git ${CMakeAll_DIR})
endif()
execute_process(COMMAND ${GIT} checkout v1.0 WORKING_DIRECTORY ${CMakeAll_DIR})
find_package(CMakeAll 1.0 REQUIRED HINTS ${CMakeAll_DIR})
```


## Minimal Example

```cmake
cmake_minimum_required(VERSION 2.8.7)
project(HelloWorld)

find_package(CMakeAll 1.0 REQUIRED)

cma_add_projects(
  "/source/ProjectA.cmake"
  "/source/ProjectB.cmake")

cma_configure_projects()
```
where `ProjectN.cmake` is referred to as a *project definition*.


## Project Definition

An example definition for ProjectB may be as follows.

```cmake
set(EP_REQUIRED_PROJECTS ProjectA)
set(EP_URL git://github.com/auneri/ProjectB.git)
set(EP_OPTION_NAME USE_ProjectB)

list(APPEND EP_LIBRARYPATH @BINARY_DIR@/@LIBDIR@/@INTDIR@)

if(USE_Python)
  list(APPEND EP_REQUIRED_PROJECTS Python)
  list(APPEND EP_PYTHONPATH @BINARY_DIR@/Python)
endif()

cma_end_definition()
# -----------------------------------------------------------------------------

set(CMAKE_ARGS
  -DBUILD_PYTHON_BINDINGS:BOOL=${USE_Python}
  -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE})

ExternalProject_Add(${EP_NAME}
  DEPENDS ${EP_REQUIRED_PROJECTS}
  # download
  GIT_REPOSITORY ${EP_URL}
  GIT_TAG v1.0
  # patch
  # update
  # configure
  SOURCE_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}
  CMAKE_ARGS ${CMAKE_ARGS}
  # build
  BINARY_DIR ${PROJECT_BINARY_DIR}/${EP_NAME}-build
  # install
  INSTALL_COMMAND ""
  # test)
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


## Launcher

Each project may define its own modifications to the environment through the following variables.

```cmake
# environment variables for launcher
set(EP_PATH "")
set(EP_LIBRARYPATH "")
set(EP_PYTHONPATH "")
set(EP_MATLABPATH "")
set(EP_ENVVAR "")

# variables that expand at build-time to help with environment variable
set(INTDIR "@INTDIR@")
set(LIBDIR "@LIBDIR@")
set(SOURCE_DIR "@SOURCE_DIR@")
set(BINARY_DIR "@BINARY_DIR@")
set(INSTALL_DIR "@INSTALL_DIR@")
```

which are then used to configure a cross-platform launcher script that can be used as follows.

```bash
cmake -P /binary/HelloWorld.cmake
```


## Advanced Example

```cmake
cmake_minimum_required(VERSION 2.8.7)
project(HelloWorld)

find_package(CMakeAll 1.0 REQUIRED)

cma_add_projects(
  ProjectA ProjectB ProjectC
  PREFIX "${CMA_PROJECTS_DIR}/"
  SUFFIX ".cmake")

cma_configure_projects(RESOLVE_DEPENDENCIES VERIFY_URLS)

cma_print_projects(SELECTED)

cma_test_projects(ProjectA ProjectB)

cma_package_projects(ProjectA ProjectC)

cma_configure_launcher()
```
