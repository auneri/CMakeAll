#! \file
#! \author Ali Uneri
#! \date 2013-05-03


# -----------------------------------------------------------------------------
#! Return from project definition, if only reading.
macro(cmt_end_definition)
  if(DEFINED EP_READONLY)
    return()
  endif()
endmacro()
