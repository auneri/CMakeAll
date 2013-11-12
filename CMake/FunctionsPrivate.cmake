#! \file
#! \author Ali Uneri
#! \date 2012-09-11


# -----------------------------------------------------------------------------
#! Configure a project from its definition.
function(cma_configure_project DEFINITION)
  cma_read_definition(${DEFINITION})
  set(NAME ${EP_NAME})
  set(REQUIRED_OPTIONS ${EP_REQUIRED_OPTIONS})
  set(REQUIRED_PROJECTS ${EP_REQUIRED_PROJECTS})

  # check for circular dependencies
  list(FIND PROJECTS_ADDED ${NAME} I)
  list(APPEND PROJECTS_ADDED ${NAME})
  if(NOT I EQUAL -1)
    string(REPLACE ";" " < " DEPENDENCIES "${PROJECTS_ADDED}")
    message(FATAL_ERROR "Circular dependency detected: ${DEPENDENCIES}")
  endif()

  # return if project is not selected
  if(NOT ${EP_OPTION_NAME})
    return()
  endif()

  # return if project is already added
  if(TARGET ${NAME})
    return()
  endif()

  # validate required options
  foreach(REQUIRED_OPTION ${REQUIRED_OPTIONS})
    if(NOT ${REQUIRED_OPTION})
      message(FATAL_ERROR "${NAME} requires ${REQUIRED_OPTION}")
    endif()
  endforeach()

  # validate required projects
  foreach(REQUIRED_PROJECT ${REQUIRED_PROJECTS})
    list(FIND CMA_PROJECTS ${REQUIRED_PROJECT} I)
    if(I EQUAL -1)
      message(FATAL_ERROR "Failed to locate project definition for ${REQUIRED_PROJECT}")
    endif()
    list(GET CMA_DEFINITIONS ${I} REQUIRED_DEFINITION)
    cma_read_definition(${REQUIRED_DEFINITION})

    if(NOT ${EP_OPTION_NAME})
      message(FATAL_ERROR "${NAME} requires ${REQUIRED_PROJECT}")
    endif()
    cma_configure_project(${REQUIRED_DEFINITION})
  endforeach()

  cma_read_definition(${DEFINITION})
  cma_add_definition(${DEFINITION})
endfunction()


# -----------------------------------------------------------------------------
#! Compute maximum length of provided list of strings.
function(cma_string_length_max INPUTS LENGTH_MAX_)
  set(LENGTH_MAX 0)
  foreach(INPUT ${INPUTS})
    string(LENGTH ${INPUT} LENGTH_INPUT)
    if(LENGTH_INPUT GREATER LENGTH_MAX)
      set(LENGTH_MAX ${LENGTH_INPUT})
    endif()
  endforeach()
  set(${LENGTH_MAX_} ${LENGTH_MAX} PARENT_SCOPE)
endfunction()


# -----------------------------------------------------------------------------
#! Left pad provided string until desired length is reached.
function(cma_string_pad INPUT LENGTH_OUTPUT PAD_CHAR OUTPUT_)
  string(LENGTH ${INPUT} LENGTH_INPUT)
  math(EXPR LENGTH_PAD "${LENGTH_OUTPUT} - ${LENGTH_INPUT}")
  set(RESULT ${INPUT})
  if(LENGTH_PAD GREATER 0)
    math(EXPR REQUIRED_MINUS_ONE "${LENGTH_PAD} - 1")
    foreach(I RANGE ${REQUIRED_MINUS_ONE})
      set(RESULT ${PAD_CHAR}${RESULT})
    endforeach()
  endif()
  set(${OUTPUT_} ${RESULT} PARENT_SCOPE)
endfunction()
