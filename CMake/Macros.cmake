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
