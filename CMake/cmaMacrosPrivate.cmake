#! \file
#! \author Ali Uneri
#! \date 2013-05-03
#! \brief Variables used to define a project.


# -----------------------------------------------------------------------------
#! Include project definition.
macro(cma_add_definition DEFINITION)
  set(EP_READONLY)
  include(${DEFINITION})
endmacro()


# -----------------------------------------------------------------------------
#! Initialize, [document] and read project definition.
macro(cma_read_definition DEFINITION)
  get_filename_component(FILENAME ${DEFINITION} NAME_WE)
  get_filename_component(DIR ${DEFINITION} DIRECTORY)
  get_filename_component(DIRNAME ${DIR} NAME)
  string(TOUPPER ${DIRNAME} DIRNAME)

  #! Project name.
  set(EP_NAME "${FILENAME}")
  #! List of required projects.
  set(EP_REQUIRED_PROJECTS "")
  #! List of required options.
  set(EP_REQUIRED_OPTIONS "")
  #! URL(s) of remote location to be verified.
  set(EP_URL)
  #! Patch file to apply.
  set(EP_PATCH "")

  #! Project CMake option.
  set(EP_OPTION_NAME "${DIRNAME}_${EP_NAME}")
  #! Default value of option.
  set(EP_OPTION_DEFAULT OFF)
  #! Hide option until requirements are met.
  set(EP_OPTION_DEPENDENT OFF)
  #! Option description.
  set(EP_OPTION_DESCRIPTION "")
  #! Mark option as advanced.
  set(EP_OPTION_ADVANCED OFF)
  #! Environment variables.
  set(EP_ENVVAR "")

  #! Variables that expand at build-time.
  set(INTDIR "@INTDIR@")
  set(LIBDIR "@LIBDIR@")
  set(SOURCE_DIR)
  set(BINARY_DIR)
  set(INSTALL_DIR)

  set(EP_READONLY ON)
  include(${DEFINITION})
endmacro()
