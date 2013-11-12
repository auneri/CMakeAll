if(EXISTS ${SOURCE_DIR}/.svn)
  set(REVERT_COMMAND ${SVN_EXECUTABLE} revert --recursive .)
elseif(EXISTS ${SOURCE_DIR}/.git)
  set(REVERT_COMMAND ${GIT_EXECUTABLE} checkout .)
else()
  set(REVERT_COMMAND ${CMAKE_COMMAND} -E echo "Nothing to revert in ${SOURCE_DIR}")
endif()

execute_process(
  COMMAND ${REVERT_COMMAND}
  WORKING_DIRECTORY ${SOURCE_DIR})

if(DEFINED PATCH_EXECUTABLE AND DEFINED PATCH_FILE)
  execute_process(
    COMMAND ${PATCH_EXECUTABLE} --fuzz 1 --strip 0 --input ${PATCH_FILE}
    WORKING_DIRECTORY ${SOURCE_DIR})
endif()
