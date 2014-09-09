if(EXISTS ${SOURCE_DIR}/.git)
  set(REVERT_COMMAND ${GIT_EXECUTABLE} checkout .)
  set(PATCH_COMMAND ${GIT_EXECUTABLE} apply ${PATCH_FILE})
elseif(EXISTS ${SOURCE_DIR}/.hg)
  set(REVERT_COMMAND ${HG_EXECUTABLE} revert --all)
  set(PATCH_COMMAND ${HG_EXECUTABLE} import --no-commit ${PATCH_FILE})
elseif(EXISTS ${SOURCE_DIR}/.svn)
  set(REVERT_COMMAND ${SVN_EXECUTABLE} revert --recursive .)
  set(PATCH_COMMAND ${SVN_EXECUTABLE} patch ${PATCH_FILE})
else()
  set(REVERT_COMMAND ${CMAKE_COMMAND} -E echo "Skipping revert, \"${SOURCE_DIR}\" is not under git/hg/svn version control")
  set(PATCH_COMMAND ${PATCH_EXECUTABLE} --input=${PATCH_FILE})
endif()

execute_process(
  COMMAND ${REVERT_COMMAND}
  WORKING_DIRECTORY ${SOURCE_DIR})

if(DEFINED PATCH_FILE)
  execute_process(
    COMMAND ${PATCH_COMMAND}
    WORKING_DIRECTORY ${SOURCE_DIR})
endif()
