set(LIBDIR lib)
if(WIN32)
  set(LIBDIR bin)
endif()

string(REPLACE "::" ";" ENVVAR "${ENVVAR}")
string(REPLACE "::" ";" PATH "${PATH}")
string(REPLACE "::" ";" LIBRARYPATH "${LIBRARYPATH}")
string(REPLACE "::" ";" PYTHONPATH "${PYTHONPATH}")
string(REPLACE "::" ";" MATLABPATH "${MATLABPATH}")

string(CONFIGURE "${ENVVAR}" ENVVAR @ONLY)
string(CONFIGURE "${PATH}" PATH @ONLY)
string(CONFIGURE "${LIBRARYPATH}" LIBRARYPATH @ONLY)
string(CONFIGURE "${PYTHONPATH}" PYTHONPATH @ONLY)
string(CONFIGURE "${MATLABPATH}" MATLABPATH @ONLY)

# configure launcher
configure_file(
  ${SOURCE_DIR}/Launcher.cmake.in
  ${BINARY_DIR}/${NAME}.cmake
  @ONLY)

# configure path helpers
foreach(X ${PYTHONPATH})
  file(TO_NATIVE_PATH ${X} Y)
  list(APPEND NATIVE_PYTHONPATH '${Y}')
endforeach()
foreach(X ${MATLABPATH})
  file(TO_NATIVE_PATH ${X} Y)
  list(APPEND NATIVE_MATLABPATH '${Y}')
endforeach()

string(REPLACE ";" ", " PYTHONPATH "${NATIVE_PYTHONPATH}")
string(REPLACE ";" ", " MATLABPATH "${NATIVE_MATLABPATH}")

foreach(EXTENSION py m)
  configure_file(
    ${SOURCE_DIR}/Path.${EXTENSION}.in
    ${BINARY_DIR}/Path.${EXTENSION}
    @ONLY)
endforeach()

# configure patch helper
if(UNIX)
  file(COPY
    ${SOURCE_DIR}/Patch.sh
    DESTINATION ${BINARY_DIR}
    FILE_PERMISSIONS
      OWNER_READ OWNER_WRITE OWNER_EXECUTE
      GROUP_READ GROUP_EXECUTE
      WORLD_READ WORLD_EXECUTE)
endif()
