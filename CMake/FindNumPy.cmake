if(PYTHON_EXECUTABLE)
  execute_process(
    COMMAND ${PYTHON_EXECUTABLE} -c "import numpy; print numpy.get_include()"
    ERROR_QUIET
    RESULT_VARIABLE RESULT
    OUTPUT_VARIABLE OUTPUT
    OUTPUT_STRIP_TRAILING_WHITESPACE)
  if(NOT RESULT)
    set(NUMPY_INCLUDE_DIR ${OUTPUT})
  endif()
endif()

find_path(PYTHON_NUMPY_INCLUDE_DIR arrayobject.h
  HINTS "${NUMPY_INCLUDE_DIR}/numpy"
        "${PYTHON_INCLUDE_PATH}/numpy"
  DOC "Directory containing arrayobject.h of NumPy.")
mark_as_advanced(PYTHON_NUMPY_INCLUDE_DIR)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(NumPy DEFAULT_MSG PYTHON_NUMPY_INCLUDE_DIR)
