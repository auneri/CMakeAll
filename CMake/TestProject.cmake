execute_process(
  COMMAND ${CMAKE_COMMAND} -P ${LAUNCHER} ${CMAKE_CTEST_COMMAND} --build-config ${INTDIR} --output-on-failure
  WORKING_DIRECTORY ${BINARY_DIR}
  ERROR_QUIET)
