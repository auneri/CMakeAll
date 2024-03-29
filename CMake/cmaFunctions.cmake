#! \file
#! \author Ali Uneri
#! \date 2012-09-11
#! \brief Public API of CMakeAll.


# -----------------------------------------------------------------------------
#! Cache project definitions and define CMake options.
function(cma_add_projects)
  cmake_parse_arguments(CMA "" "PREFIX;SUFFIX" "" ${ARGN})

  set(PROJECTS "")
  set(DEFINITIONS "")
  foreach(DEFINITION ${CMA_UNPARSED_ARGUMENTS})
    if(CMA_PREFIX)
      set(DEFINITION "${CMA_PREFIX}${DEFINITION}")
    endif()
    if(CMA_SUFFIX)
      set(DEFINITION "${DEFINITION}${CMA_SUFFIX}")
    endif()
    cma_read_definition(${DEFINITION})

    # check if project is already defined
    list(FIND PROJECTS ${EP_NAME} I)
    if(NOT I EQUAL -1)
      message(FATAL_ERROR "${EP_NAME} project was already defined")
    endif()

    list(APPEND PROJECTS ${EP_NAME})
    list(APPEND DEFINITIONS ${DEFINITION})

    # define a CMake option for project
    set(REQUIREDS ${EP_REQUIRED_PROJECTS} ${EP_REQUIRED_OPTIONS})
    if(EP_OPTION_DEPENDENT AND REQUIREDS)
      cmake_dependent_option(${EP_OPTION_NAME} "${EP_OPTION_DESCRIPTION}" ${EP_OPTION_DEFAULT} ${REQUIREDS} OFF)
    else()
      option(${EP_OPTION_NAME} "${EP_OPTION_DESCRIPTION}" ${EP_OPTION_DEFAULT})
    endif()
    if(EP_OPTION_ADVANCED)
      mark_as_advanced(${EP_OPTION_NAME})
    endif()

  endforeach()
  set(CMA_PROJECTS "${CMA_PROJECTS};${PROJECTS}" CACHE INTERNAL "")
  set(CMA_DEFINITIONS "${CMA_DEFINITIONS};${DEFINITIONS}" CACHE INTERNAL "")
endfunction()


# -----------------------------------------------------------------------------
#! Configure the CMake launcher script.
function(cma_configure_launcher)
  set(EP_ENVVARS)
  foreach(DEFINITION ${CMA_DEFINITIONS})
    cma_read_definition(${DEFINITION})
    if(${EP_OPTION_NAME})
      ExternalProject_Get_Property(${EP_NAME} SOURCE_DIR)
      ExternalProject_Get_Property(${EP_NAME} BINARY_DIR)
      ExternalProject_Get_Property(${EP_NAME} INSTALL_DIR)
      string(CONFIGURE "${EP_ENVVAR}" EP_ENVVAR @ONLY)
      list(APPEND EP_ENVVARS ${EP_ENVVAR})
    endif()
  endforeach()
  string(REPLACE ";" "::" ENVVAR "${EP_ENVVARS}")

  add_custom_target(Launcher ALL
    COMMAND ${CMAKE_COMMAND}
      -DENVVAR:STRING=${ENVVAR}
      -DINTDIR:STRING=${CMAKE_CFG_INTDIR}
      -DSOURCE_DIR:PATH=${CMA_CMAKE_DIR}
      -DBINARY_DIR:PATH=${PROJECT_BINARY_DIR}
      -DNAME:STRING=${PROJECT_NAME}
      -DCUSTOMIZATIONS:PATH=${ARGV0}
      -P ${CMA_CMAKE_DIR}/ConfigureLauncher.cmake
    DEPENDS ${CMA_CMAKE_DIR}/Launcher.cmake.in)
  set_target_properties(Launcher PROPERTIES
    FOLDER "Launchers")
endfunction()


# -----------------------------------------------------------------------------
#! Configure added projects.
function(cma_configure_projects)
  cmake_parse_arguments(CMA "" "" "" ${ARGN})

  if(CMakeAll_RESOLVE_DEPENDENCIES)
    set(DEPENDENCY_RESOLVED ON)
    while(DEPENDENCY_RESOLVED)
      set(DEPENDENCY_RESOLVED OFF)

      foreach(DEFINITION ${CMA_DEFINITIONS})
        cma_read_definition(${DEFINITION})

        set(NAME ${EP_NAME})
        set(OPTION_NAME ${EP_OPTION_NAME})
        set(REQUIRED_PROJECTS ${EP_REQUIRED_PROJECTS})

        if(${OPTION_NAME})
          foreach(REQUIRED_PROJECT ${REQUIRED_PROJECTS})
            list(FIND CMA_PROJECTS ${REQUIRED_PROJECT} I)
            if(I EQUAL -1)
              message(FATAL_ERROR "Failed to locate project definition for ${REQUIRED_PROJECT}")
            endif()
            list(GET CMA_DEFINITIONS ${I} REQUIRED_DEFINITION)
            cma_read_definition(${REQUIRED_DEFINITION})

            if(NOT ${EP_OPTION_NAME})
              message("${NAME} is enabling ${REQUIRED_PROJECT}")
              set(${EP_OPTION_NAME} ON CACHE BOOL "${EP_OPTION_DESCRIPTION}" FORCE)
              set(DEPENDENCY_RESOLVED ON)
            endif()
          endforeach()
        endif()
      endforeach()
    endwhile()
  endif()

  if(CMakeAll_VERIFY_URLS)
    foreach(DEFINITION ${CMA_DEFINITIONS})
      cma_read_definition(${DEFINITION})
      if(${EP_OPTION_NAME})
        foreach(URL ${EP_URL})
          if(URL MATCHES "^svn" OR URL MATCHES "^http.*/svn.*/trunk" OR URL MATCHES "^http.*/svn.*/branches" OR URL MATCHES "^http.*/svn.*/tags")
            find_program(SVN_EXECUTABLE svn)
            mark_as_advanced(SVN_EXECUTABLE)
            if(SVN_EXECUTABLE)
              execute_process(
                COMMAND ${SVN_EXECUTABLE} --non-interactive --trust-server-cert info ${URL}
                OUTPUT_QUIET
                ERROR_QUIET
                RESULT_VARIABLE RESULT)
            else()
              set(RESULT -1)
            endif()
          elseif(URL MATCHES "^git" OR URL MATCHES "^http.*\\.git$")
            find_program(GIT_EXECUTABLE git)
            mark_as_advanced(GIT_EXECUTABLE)
            if(GIT_EXECUTABLE)
              execute_process(
                COMMAND ${GIT_EXECUTABLE} ls-remote ${URL}
                OUTPUT_QUIET
                ERROR_QUIET
                RESULT_VARIABLE RESULT)
            else()
              set(RESULT -1)
            endif()
          else()
            file(DOWNLOAD
                ${URL}
                ${CMAKE_CURRENT_BINARY_DIR}/CMakeAll_VERIFY_URLS
                TIMEOUT 2
              STATUS STATUS)
            list(GET STATUS 0 STATUS_CODE)
            if(STATUS_CODE EQUAL 28 OR STATUS_CODE EQUAL 0)  # expecting timeout (28) or no error (0)
              set(RESULT 0)
            else()
              message("${STATUS}")
              set(RESULT 1)
            endif()
          endif()
          if(RESULT EQUAL 0)
            message(STATUS "Verified connection to ${URL}")
          elseif(RESULT EQUAL -1)
            message(AUTHOR_WARNING "No tools to verify connection to ${URL}")
          else()
            message(SEND_ERROR "Failed to verify connection to ${URL}")
          endif()
        endforeach()
      endif()
    endforeach()
  endif()

  foreach(DEFINITION ${CMA_DEFINITIONS})
    set(PROJECTS_ADDED "")
    cma_configure_project(${DEFINITION})

    cma_read_definition(${DEFINITION})
    if(${EP_OPTION_NAME} AND EP_PATCH)
      cma_patch_project(${EP_NAME} ${EP_PATCH})
    endif()
  endforeach()
endfunction()


# -----------------------------------------------------------------------------
#! Create a target for executing a command via the launcher.
function(cma_launcher_target)
  cmake_parse_arguments(CMA "" "NAME" "DEPENDS" ${ARGN})
  set(TARGET_LABEL "Launch ${CMA_NAME}")
  string(REPLACE " " "" TARGET_NAME "${TARGET_LABEL}")
  add_custom_target(${TARGET_NAME}
    COMMAND ${CMAKE_COMMAND} -P ${PROJECT_BINARY_DIR}/${PROJECT_NAME}.cmake ${CMA_UNPARSED_ARGUMENTS}
    DEPENDS ${CMA_DEPENDS})
  set_target_properties(${TARGET_NAME} PROPERTIES
    PROJECT_LABEL ${TARGET_LABEL}
    FOLDER "Launchers")
endfunction()


# -----------------------------------------------------------------------------
#! Include provided projects in packaging, if marked accordingly.
function(cma_package_projects)
  set(CPACK_INSTALL_CMAKE_PROJECTS "")
  foreach(NAME ${ARGN})
    list(FIND CMA_PROJECTS ${NAME} I)
    if(I EQUAL -1)
      message(FATAL_ERROR "Failed to locate project definition for ${NAME}")
    endif()
    list(GET CMA_DEFINITIONS ${I} DEFINITION)
    cma_read_definition(${DEFINITION})

    if(${EP_OPTION_NAME})
      ExternalProject_Get_Property(${EP_NAME} BINARY_DIR)
      list(APPEND CPACK_INSTALL_CMAKE_PROJECTS "${BINARY_DIR};${EP_NAME};ALL;.")
    endif()
  endforeach()
  include(CPack)
endfunction()


# -----------------------------------------------------------------------------
#! Patch a project using the patch file provided.
function(cma_patch_project NAME PATCH_FILE)
  if(NOT EXISTS ${PATCH_FILE})
    message(FATAL_ERROR "Failed to locate ${PATCH_FILE}")
  endif()
  find_program(GIT_EXECUTABLE git)
  mark_as_advanced(GIT_EXECUTABLE)
  find_program(HG_EXECUTABLE hg)
  mark_as_advanced(HG_EXECUTABLE)
  find_program(SVN_EXECUTABLE svn)
  mark_as_advanced(SVN_EXECUTABLE)
  find_program(PATCH_EXECUTABLE patch)
  mark_as_advanced(PATCH_EXECUTABLE)

  ExternalProject_Add_Step(${NAME} RevertProject
    COMMENT "Reverting changes to '${NAME}'"
    COMMAND ${CMAKE_COMMAND}
      -DSOURCE_DIR:PATH=<SOURCE_DIR>
      -DGIT_EXECUTABLE:FILEPATH=${GIT_EXECUTABLE}
      -DHG_EXECUTABLE:FILEPATH=${HG_EXECUTABLE}
      -DSVN_EXECUTABLE:FILEPATH=${SVN_EXECUTABLE}
      -P ${CMA_CMAKE_DIR}/PatchProject.cmake
    DEPENDERS download
    DEPENDS ${PATCH_FILE}
    WORKING_DIRECTORY <SOURCE_DIR>)

  ExternalProject_Add_Step(${NAME} PatchProject
    COMMENT "Patching '${NAME}'"
    COMMAND ${CMAKE_COMMAND}
      -DSOURCE_DIR:PATH=<SOURCE_DIR>
      -DPATCH_EXECUTABLE:FILEPATH=${PATCH_EXECUTABLE}
      -DPATCH_FILE:FILEPATH=${PATCH_FILE}
      -DGIT_EXECUTABLE:FILEPATH=${GIT_EXECUTABLE}
      -DHG_EXECUTABLE:FILEPATH=${HG_EXECUTABLE}
      -DSVN_EXECUTABLE:FILEPATH=${SVN_EXECUTABLE}
      -P ${CMA_CMAKE_DIR}/PatchProject.cmake
    DEPENDEES update
    DEPENDERS configure
    WORKING_DIRECTORY <SOURCE_DIR>)
endfunction()


# -----------------------------------------------------------------------------
#! Print dependenty graph to stdout and PROJECT_NAME.dot, try compiling to PDF.
function(cma_print_projects)
  cmake_parse_arguments(CMA "" "" "" ${ARGN})
  set(BASENAME "${PROJECT_BINARY_DIR}/${PROJECT_NAME}")
  file(WRITE ${BASENAME}.dot "digraph ${PROJECT_NAME} {\n")
  file(APPEND ${BASENAME}.dot "  rankdir=LR;\n")

  # compute maximum name length for printing purposes
  set(LENGTH_MAX 0)
  foreach(DEFINITION ${CMA_DEFINITIONS})
    cma_read_definition(${DEFINITION})
    if(${EP_OPTION_NAME} OR CMakeAll_PRINT_ALL_PROJECTS)
      string(LENGTH ${EP_NAME} LENGTH_NAME)
      if(LENGTH_NAME GREATER LENGTH_MAX)
        set(LENGTH_MAX ${LENGTH_NAME})
      endif()
    endif()
    if(${EP_OPTION_NAME} AND NOT CMakeAll_PRINT_ALL_PROJECTS)
      file(APPEND ${BASENAME}.dot "  ${EP_NAME};\n")
    elseif(${EP_OPTION_NAME} AND CMakeAll_PRINT_ALL_PROJECTS)
      file(APPEND ${BASENAME}.dot "  ${EP_NAME} [color=limegreen,style=filled];\n")
    elseif(CMakeAll_PRINT_ALL_PROJECTS)
      file(APPEND ${BASENAME}.dot "  ${EP_NAME} [color=lightgray,style=filled];\n")
    endif()
  endforeach()

  foreach(DEFINITION ${CMA_DEFINITIONS})
    cma_read_definition(${DEFINITION})
    cma_string_pad(${EP_NAME} ${LENGTH_MAX} " " NAME)
    if(${EP_OPTION_NAME} AND NOT CMakeAll_PRINT_ALL_PROJECTS)
      set(STATUS "> ${NAME}")
    elseif(${EP_OPTION_NAME} AND CMakeAll_PRINT_ALL_PROJECTS)
      set(STATUS "[x] ${NAME}")
    elseif(CMakeAll_PRINT_ALL_PROJECTS)
      set(STATUS "[ ] ${NAME}")
    endif()
    if(EP_REQUIRED_PROJECTS)
      set(STATUS "${STATUS} <")
    endif()

    foreach(REQUIRED ${EP_REQUIRED_PROJECTS})
      if(${EP_OPTION_NAME})
        set(STATUS "${STATUS} ${REQUIRED}")
        file(APPEND ${BASENAME}.dot "  ${EP_NAME} -> ${REQUIRED};\n")
      elseif(CMakeAll_PRINT_ALL_PROJECTS)
        set(STATUS "${STATUS} ${REQUIRED}")
        file(APPEND ${BASENAME}.dot "  ${EP_NAME} -> ${REQUIRED} [style=dotted];\n")
      endif()
    endforeach()

    if(${EP_OPTION_NAME} OR CMakeAll_PRINT_ALL_PROJECTS)
      message(STATUS "${STATUS}")
    endif()
  endforeach()
  file(APPEND ${BASENAME}.dot "}\n")

  find_program(DOT_EXECUTABLE dot)
  mark_as_advanced(DOT_EXECUTABLE)
  if(DOT_EXECUTABLE)
    execute_process(
      COMMAND ${DOT_EXECUTABLE} -Tpdf ${BASENAME}.dot -o ${BASENAME}.pdf
      OUTPUT_QUIET
      ERROR_QUIET)
  endif()
endfunction()


# -----------------------------------------------------------------------------
#! Get Git revision of a project source.
function(cma_git_revision SOURCE_DIR REVISION_)
  set(REVISION 0)  # default to 0

  find_program(GIT_EXECUTABLE git)
  mark_as_advanced(GIT_EXECUTABLE)
  if(GIT_EXECUTABLE)
    execute_process(
      COMMAND ${GIT_EXECUTABLE} rev-list HEAD --count
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      RESULT_VARIABLE RESULT
      OUTPUT_VARIABLE GIT_WC_REVISION
      OUTPUT_STRIP_TRAILING_WHITESPACE
      ERROR_QUIET)
    if(RESULT EQUAL 0)
      set(REVISION ${GIT_WC_REVISION})
    endif()
  endif()

  set(${REVISION_} ${REVISION} PARENT_SCOPE)
endfunction()


# -----------------------------------------------------------------------------
#! Get Subversion revision of a project source.
function(cma_subversion_revision SOURCE_DIR REVISION_)
  set(REVISION 0)  # default to 0

  find_program(SVN_EXECUTABLE svn)
  mark_as_advanced(SVN_EXECUTABLE)
  if(SUBVERSION_FOUND)
    execute_process(
      COMMAND ${SVN_EXECUTABLE} info
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      RESULT_VARIABLE RESULT
      OUTPUT_QUIET
      ERROR_QUIET)
    if(RESULT EQUAL 0)
      Subversion_WC_INFO(${PROJECT_SOURCE_DIR} SVN)
      set(REVISION ${SVN_WC_REVISION})
    endif()
  endif()

  # if using git-svn
  find_program(GIT_EXECUTABLE git)
  mark_as_advanced(GIT_EXECUTABLE)
  if(GIT_EXECUTABLE)
    execute_process(
      COMMAND ${GIT_EXECUTABLE} rev-parse HEAD
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      RESULT_VARIABLE RESULT1
      OUTPUT_VARIABLE GIT_WC_REVISION
      OUTPUT_STRIP_TRAILING_WHITESPACE
      ERROR_QUIET)
    execute_process(
      COMMAND ${GIT_EXECUTABLE} svn find-rev ${GIT_WC_REVISION}
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      RESULT_VARIABLE RESULT2
      OUTPUT_VARIABLE SVN_WC_REVISION
      OUTPUT_STRIP_TRAILING_WHITESPACE
      ERROR_QUIET)
    if(RESULT1 EQUAL 0 AND RESULT2 EQUAL 0)
      set(REVISION ${SVN_WC_REVISION})
    endif()
  endif()

  set(${REVISION_} ${REVISION} PARENT_SCOPE)
endfunction()


# -----------------------------------------------------------------------------
#! Include provided projects in testing, if marked accordingly.
function(cma_test_projects)
  add_custom_target("tests")
  set_target_properties("tests" PROPERTIES PROJECT_LABEL "ALL_TESTS")
  foreach(NAME ${ARGN})
    list(FIND CMA_PROJECTS ${NAME} I)
    if(I EQUAL -1)
      message(FATAL_ERROR "Failed to locate project definition for ${NAME}")
    endif()
    list(GET CMA_DEFINITIONS ${I} DEFINITION)
    cma_read_definition(${DEFINITION})

    if(${EP_OPTION_NAME})
      ExternalProject_Get_Property(${EP_NAME} BINARY_DIR)
      add_custom_command(
        COMMENT "Testing '${EP_NAME}'"
        TARGET "tests"
        COMMAND ${CMAKE_COMMAND}
          -DLAUNCHER:FILEPATH=${PROJECT_BINARY_DIR}/${PROJECT_NAME}.cmake
          -DINTDIR:STRING=${CMAKE_CFG_INTDIR}
          -DBINARY_DIR:PATH=${BINARY_DIR}
          -P ${CMA_CMAKE_DIR}/TestProject.cmake
        WORKING_DIRECTORY ${BINARY_DIR})
    endif()
  endforeach()
endfunction()


# -----------------------------------------------------------------------------
#! Touch projects (retrigger execution of an external project's steps), if marked accordingly.
function(cma_touch_projects)
  foreach(NAME ${ARGN})
    list(FIND CMA_PROJECTS ${NAME} I)
    if(I EQUAL -1)
      message(FATAL_ERROR "Failed to locate project definition for ${NAME}")
    endif()
    list(GET CMA_DEFINITIONS ${I} DEFINITION)
    cma_read_definition(${DEFINITION})

    if(${EP_OPTION_NAME})
      ExternalProject_Add_Step(${EP_NAME} TouchProject
        COMMENT "Touching '${EP_NAME}'"
        COMMAND ${CMAKE_COMMAND} -E echo "Touched '${EP_NAME}'"
        DEPENDEES update
        DEPENDERS configure
        ALWAYS 1)
    endif()
  endforeach()
endfunction()
