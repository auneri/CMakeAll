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
#! Define environment variables.
macro(cma_envvar NAME)
  cmake_parse_arguments(CMA "APPEND;PREPEND" "IF" "" ${ARGN})
  if((NOT CMA_IF) OR (${CMA_IF}))
    if("${NAME}" STREQUAL "@LIBRARYPATH@")
      if(WIN32)
        set(ENVVAR "PATH")
      elseif(APPLE)
        set(ENVVAR "DYLD_FALLBACK_LIBRARY_PATH")
      elseif(UNIX)
        set(ENVVAR "LD_LIBRARY_PATH")
      else()
        message(FATAL_ERROR "Platform is not supported")
      endif()
    else()
      set(ENVVAR "${NAME}")
    endif()

    foreach(X ${CMA_UNPARSED_ARGUMENTS})
      if(CMA_APPEND)
        list(APPEND EP_ENVVAR "${ENVVAR}+=${X}")
      elseif(CMA_PREPEND)
        list(APPEND EP_ENVVAR "${ENVVAR}=+${X}")
      else()
        list(APPEND EP_ENVVAR "${ENVVAR}==${X}")
      endif()
    endforeach()
  endif()
endmacro()


# -----------------------------------------------------------------------------
#! Built-in list method with an optional IF argument.
macro(cma_list)
  cmake_parse_arguments(CMA "" "IF" "" ${ARGN})
  if((NOT CMA_IF) OR (${CMA_IF}))
    list(${CMA_UNPARSED_ARGUMENTS})
  endif()
endmacro()
