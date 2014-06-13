set(LIBDIR lib)
if(WIN32)
  set(LIBDIR bin)
endif()
string(REPLACE "::" ";" ENVVAR "${ENVVAR}")
string(CONFIGURE "${ENVVAR}" ENVVAR @ONLY)

# configure launcher
configure_file(
  ${SOURCE_DIR}/Launcher.cmake.in
  ${BINARY_DIR}/${NAME}.cmake
  @ONLY)

# configure path helpers
file(WRITE ${BINARY_DIR}/Path.py "import sys\n")
file(WRITE ${BINARY_DIR}/Path.m "")

foreach(X ${ENVVAR})
  string(FIND ${X} "+=" ENVVAR_APPEND)
  string(FIND ${X} "=+" ENVVAR_PREPEND)
  string(FIND ${X} "==" ENVVAR_SET)
  if(NOT ENVVAR_APPEND EQUAL -1)
    string(REPLACE "+=" ";" X ${X})
  elseif(NOT ENVVAR_PREPEND EQUAL -1)
    string(REPLACE "=+" ";" X ${X})
  elseif(NOT ENVVAR_SET EQUAL -1)
    string(REPLACE "==" ";" X ${X})
  endif()
  list(GET X 0 KEY)
  list(GET X 1 VALUE)
  file(TO_NATIVE_PATH ${VALUE} VALUE)
  if(${KEY} STREQUAL "PYTHONPATH")
    if(NOT ENVVAR_APPEND EQUAL -1)
      file(APPEND ${BINARY_DIR}/Path.py "sys.path.append(r'${VALUE}')\n")
    elseif(NOT ENVVAR_PREPEND EQUAL -1)
      file(APPEND ${BINARY_DIR}/Path.py "sys.path.insert(0, r'${VALUE}')\n")
    elseif(NOT ENVVAR_SET EQUAL -1)
      message(FATAL_ERROR "Can only append or prepend to PYTHONPATH")
    endif()
  elseif(${KEY} STREQUAL "MATLABPATH")
    if(NOT ENVVAR_APPEND EQUAL -1)
      file(APPEND ${BINARY_DIR}/Path.m "addpath('${VALUE}', '-end');\n")
    elseif(NOT ENVVAR_PREPEND EQUAL -1)
      file(APPEND ${BINARY_DIR}/Path.m "addpath('${VALUE}');\n")
    elseif(NOT ENVVAR_SET EQUAL -1)
      message(FATAL_ERROR "Can only append or prepend to MATLABPATH")
    endif()
  endif()
endforeach()

# configure patch helper
file(COPY
  ${SOURCE_DIR}/Patch.sh
  DESTINATION ${BINARY_DIR}
  FILE_PERMISSIONS
    OWNER_READ OWNER_WRITE OWNER_EXECUTE
    GROUP_READ GROUP_EXECUTE
    WORLD_READ WORLD_EXECUTE)
