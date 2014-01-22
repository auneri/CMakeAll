#! \file
#! \author Ali Uneri
#! \date 2013-05-03
#! \brief Public API of CMakeAll.


# -----------------------------------------------------------------------------
#! Return from project definition, if only reading.
macro(cma_end_definition)
  if(DEFINED EP_READONLY)
    return()
  endif()
endmacro()


# -----------------------------------------------------------------------------
#! Built-in list method with an optional IF argument.
macro(cma_list)
  cmake_parse_arguments(CMA "" "IF" "" ${ARGN})
  if(${CMA_IF})
    list(${CMA_UNPARSED_ARGUMENTS})
  endif()
endmacro()
