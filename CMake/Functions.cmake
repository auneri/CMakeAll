#! \file
#! \author Ali Uneri
#! \date 2012-09-11
#! \brief Public API of CmakeTools.


# -----------------------------------------------------------------------------
#! Cache project definitions and define CMake options.
function(cmt_add_projects)
  cmake_parse_arguments(CMT "" "PREFIX;SUFFIX" "" ${ARGN})

  set(PROJECTS "")
  set(DEFINITIONS "")
  foreach(DEFINITION ${CMT_UNPARSED_ARGUMENTS})
    if(CMT_PREFIX)
      set(DEFINITION "${CMT_PREFIX}${DEFINITION}")
    endif()
    if(CMT_SUFFIX)
      set(DEFINITION "${DEFINITION}${CMT_SUFFIX}")
    endif()
    cmt_read_definition(${DEFINITION})

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
  set(CMT_PROJECTS "${CMT_PROJECTS};${PROJECTS}" CACHE INTERNAL "")
  set(CMT_DEFINITIONS "${CMT_DEFINITIONS};${DEFINITIONS}" CACHE INTERNAL "")
endfunction()


# -----------------------------------------------------------------------------
#! Configure the CMake launcher script.
function(cmt_configure_launcher)
  set(EP_PATHS "")
  set(EP_LIBRARYPATHS "")
  set(EP_PYTHONPATHS ${PROJECT_BINARY_DIR})
  set(EP_MATLABPATHS "")
  set(EP_MODULEPATHS "")

  foreach(DEFINITION ${CMT_DEFINITIONS})
    cmt_read_definition(${DEFINITION})
    if(${EP_OPTION_NAME})
      ExternalProject_Get_Property(${EP_NAME} SOURCE_DIR)
      ExternalProject_Get_Property(${EP_NAME} BINARY_DIR)
      ExternalProject_Get_Property(${EP_NAME} INSTALL_DIR)
      string(CONFIGURE "${EP_PATH}" EP_PATH @ONLY)
      string(CONFIGURE "${EP_LIBRARYPATH}" EP_LIBRARYPATH @ONLY)
      string(CONFIGURE "${EP_PYTHONPATH}" EP_PYTHONPATH @ONLY)
      string(CONFIGURE "${EP_MATLABPATH}" EP_MATLABPATH @ONLY)
      string(CONFIGURE "${EP_MODULEPATH}" EP_MODULEPATH @ONLY)
      list(APPEND EP_PATHS ${EP_PATH})
      list(APPEND EP_LIBRARYPATHS ${EP_LIBRARYPATH})
      list(APPEND EP_PYTHONPATHS ${EP_PYTHONPATH})
      list(APPEND EP_MATLABPATHS ${EP_MATLABPATH})
      list(APPEND EP_MODULEPATHS ${EP_MODULEPATH})
    endif()
  endforeach()

  string(REPLACE ";" "::" PATH "${EP_PATHS}")
  string(REPLACE ";" "::" LIBRARYPATH "${EP_LIBRARYPATHS}")
  string(REPLACE ";" "::" PYTHONPATH "${EP_PYTHONPATHS}")
  string(REPLACE ";" "::" MATLABPATH "${EP_MATLABPATHS}")
  string(REPLACE ";" "::" MODULEPATH "${EP_MODULEPATHS}")

  add_custom_target(Launcher ALL
    COMMAND ${CMAKE_COMMAND}
      -DPATH:STRING=${PATH}
      -DLIBRARYPATH:STRING=${LIBRARYPATH}
      -DPYTHONPATH:STRING=${PYTHONPATH}
      -DMATLABPATH:STRING=${MATLABPATH}
      -DMODULEPATH:STRING=${MODULEPATH}
      -DINTDIR:STRING=${CMAKE_CFG_INTDIR}
      -DSOURCE_DIR:PATH=${CMT_CMAKE_DIR}
      -DBINARY_DIR:PATH=${PROJECT_BINARY_DIR}
      -DNAME:STRING=${PROJECT_NAME}
      -P ${CMT_CMAKE_DIR}/ConfigureLauncher.cmake)

  add_custom_target(run_terminal COMMAND ${CMAKE_COMMAND} -P ${PROJECT_BINARY_DIR}/${PROJECT_NAME}.cmake Terminal)
  set_property(TARGET run_terminal PROPERTY PROJECT_LABEL "RUN_TERMINAL")
  if(PROJECTS_Slicer)
    add_custom_target(run_slicer COMMAND ${CMAKE_COMMAND} -P ${PROJECT_BINARY_DIR}/${PROJECT_NAME}.cmake Slicer)
    set_property(TARGET run_slicer PROPERTY PROJECT_LABEL "RUN_SLICER")
  endif()
endfunction()


# -----------------------------------------------------------------------------
#! Configure added projects.
function(cmt_configure_projects)
  cmake_parse_arguments(CMT "RESOLVE_DEPENDENCIES;VERIFY_URLS" "" "" ${ARGN})

  if(CMT_RESOLVE_DEPENDENCIES)
    set(DEPENDENCY_RESOLVED ON)
    while(DEPENDENCY_RESOLVED)
      set(DEPENDENCY_RESOLVED OFF)

      foreach(DEFINITION ${CMT_DEFINITIONS})
        cmt_read_definition(${DEFINITION})

        set(NAME ${EP_NAME})
        set(OPTION_NAME ${EP_OPTION_NAME})
        set(REQUIRED_PROJECTS ${EP_REQUIRED_PROJECTS})

        if(${OPTION_NAME})
          foreach(REQUIRED_PROJECT ${REQUIRED_PROJECTS})
            list(FIND CMT_PROJECTS ${REQUIRED_PROJECT} I)
            if(I EQUAL -1)
              message(FATAL_ERROR "Failed to locate project definition for ${REQUIRED_PROJECT}")
            endif()
            list(GET CMT_DEFINITIONS ${I} REQUIRED_DEFINITION)
            cmt_read_definition(${REQUIRED_DEFINITION})

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

  if(CMT_VERIFY_URLS)
    foreach(DEFINITION ${CMT_DEFINITIONS})
      cmt_read_definition(${DEFINITION})
      if(${EP_OPTION_NAME})
        foreach(URL ${EP_URL})
          if(URL MATCHES "^svn://")
            execute_process(
              COMMAND ${CMT_SVN_EXECUTABLE} info ${URL}
              OUTPUT_QUIET
              ERROR_QUIET
              RESULT_VARIABLE RESULT)
          elseif(URL MATCHES "^git://")
            execute_process(
              COMMAND ${CMT_GIT_EXECUTABLE} ls-remote ${URL}
              OUTPUT_QUIET
              ERROR_QUIET
              RESULT_VARIABLE RESULT)
          else()
            find_package(PythonInterp)
            if(PYTHONINTERP_FOUND)
              execute_process(
                COMMAND ${PYTHON_EXECUTABLE} -c "import urllib2; urllib2.urlopen('${URL}')"
                ERROR_QUIET
                RESULT_VARIABLE RESULT)
            else()
              message(AUTHOR_WARNING "No tools to verify connection to ${URL}")
              set(RESULT 1)
            endif()
          endif()
          if(NOT RESULT)
            message(STATUS "Verified connection to ${URL}")
          else()
            message(ERROR "Failed to verify connection to ${URL}")
          endif()
        endforeach()
      endif()
    endforeach()
  endif()

  foreach(DEFINITION ${CMT_DEFINITIONS})
    set(PROJECTS_ADDED "")
    cmt_configure_project(${DEFINITION})

    cmt_read_definition(${DEFINITION})
    if(${EP_OPTION_NAME} AND EP_PATCH)
      cmt_patch_project(${EP_NAME} ${EP_PATCH})
    endif()
  endforeach()
endfunction()


# -----------------------------------------------------------------------------
#! Include provided projects in packaging, if marked accordingly.
function(cmt_package_projects)
  set(CPACK_INSTALL_CMAKE_PROJECTS "")
  foreach(NAME ${ARGN})
    list(FIND CMT_PROJECTS ${NAME} I)
    if(I EQUAL -1)
      message(FATAL_ERROR "Failed to locate project definition for ${NAME}")
    endif()
    list(GET CMT_DEFINITIONS ${I} DEFINITION)
    cmt_read_definition(${DEFINITION})

    if(${EP_OPTION_NAME})
      ExternalProject_Get_Property(${EP_NAME} BINARY_DIR)
      list(APPEND CPACK_INSTALL_CMAKE_PROJECTS "${BINARY_DIR};${EP_NAME};ALL;.")
    endif()
  endforeach()
  include(CPack)
endfunction()


# -----------------------------------------------------------------------------
#! Patch a project using the patch file provided.
function(cmt_patch_project NAME PATCH_FILE)
  if(NOT EXISTS ${PATCH_FILE})
    message(FATAL_ERROR "Failed to locate ${PATCH_FILE}")
  endif()

  ExternalProject_Add_Step(${NAME} RevertProject
    COMMENT "Reverting changes to '${NAME}'"
    COMMAND ${CMAKE_COMMAND}
      -DGIT_EXECUTABLE:FILEPATH=${CMT_GIT_EXECUTABLE}
      -DSOURCE_DIR:PATH=<SOURCE_DIR>
      -DSVN_EXECUTABLE:FILEPATH=${CMT_SVN_EXECUTABLE}
      -P ${CMT_CMAKE_DIR}/PatchProject.cmake
    DEPENDERS download
    DEPENDS ${PATCH_FILE}
    WORKING_DIRECTORY <SOURCE_DIR>)

  ExternalProject_Add_Step(${NAME} PatchProject
    COMMENT "Patching '${NAME}'"
    COMMAND ${CMAKE_COMMAND}
      -DGIT_EXECUTABLE:FILEPATH=${CMT_GIT_EXECUTABLE}
      -DPATCH_EXECUTABLE:FILEPATH=${CMT_PATCH_EXECUTABLE}
      -DPATCH_FILE:FILEPATH=${PATCH_FILE}
      -DSOURCE_DIR:PATH=<SOURCE_DIR>
      -DSVN_EXECUTABLE:FILEPATH=${CMT_SVN_EXECUTABLE}
      -P ${CMT_CMAKE_DIR}/PatchProject.cmake
    DEPENDEES download
    DEPENDERS update
    WORKING_DIRECTORY <SOURCE_DIR>)
endfunction()


# -----------------------------------------------------------------------------
#! Include provided projects in packaging, if marked accordingly.
function(cmt_print_projects)
  cmake_parse_arguments(CMT "SELECTED" "" "" ${ARGN})

  # compute maximum name length for printing purposes
  cmt_string_length_max("${CMT_PROJECTS}" LENGTH_MAX)

  foreach(DEFINITION ${CMT_DEFINITIONS})
    cmt_read_definition(${DEFINITION})

    set(SELECTED " ")
    if(${EP_OPTION_NAME})
      set(SELECTED "+")
    endif()

    cmt_string_pad(${EP_NAME} ${LENGTH_MAX} " " NAME)

    set(REQUIREDS ${EP_REQUIRED_PROJECTS} ${EP_REQUIRED_OPTIONS})
    string(REPLACE ";" ", " REQUIREDS "${REQUIREDS}")
    if(REQUIREDS)
      set(REQUIREDS " < ${REQUIREDS}")
    endif()

    if(CMT_SELECTED AND ${EP_OPTION_NAME})
      message(STATUS "${NAME}${REQUIREDS}")
    elseif(NOT CMT_SELECTED)
      message(STATUS "[${SELECTED}] ${NAME}${REQUIREDS}")
    endif()
  endforeach()
endfunction()


# -----------------------------------------------------------------------------
#! Get Git revision of a project source.
function(cmt_git_revision SOURCE_DIR REVISION_)
  set(REVISION 0)  # default to 0

  find_package(Git QUIET)
  if(GIT_FOUND)
    execute_process(
      COMMAND ${GIT_EXECUTABLE} rev-list HEAD --count
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      RESULT_VARIABLE RESULT1
      OUTPUT_VARIABLE GIT_WC_REVISION
      OUTPUT_STRIP_TRAILING_WHITESPACE
      ERROR_QUIET)
    if(NOT RESULT1)
      set(REVISION ${GIT_WC_REVISION})
    endif()
  endif()

  set(${REVISION_} ${REVISION} PARENT_SCOPE)
endfunction()


# -----------------------------------------------------------------------------
#! Get Subversion revision of a project source.
function(cmt_subversion_revision SOURCE_DIR REVISION_)
  set(REVISION 0)  # default to 0

  find_package(Subversion QUIET)
  if(SUBVERSION_FOUND)
    execute_process(
      COMMAND ${Subversion_SVN_EXECUTABLE} info
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      RESULT_VARIABLE RESULT
      OUTPUT_QUIET
      ERROR_QUIET)
    if(NOT RESULT)
      Subversion_WC_INFO(${PROJECT_SOURCE_DIR} SVN)
      set(REVISION ${SVN_WC_REVISION})
    endif()
  endif()

  # if using git-svn
  find_package(Git QUIET)
  if(GIT_FOUND)
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
    if(NOT RESULT1 AND NOT RESULT2)
      set(REVISION ${SVN_WC_REVISION})
    endif()
  endif()

  set(${REVISION_} ${REVISION} PARENT_SCOPE)
endfunction()


# -----------------------------------------------------------------------------
#! Include provided projects in testing, if marked accordingly.
function(cmt_test_projects)
  add_custom_target("test")
  set_property(TARGET "test" PROPERTY PROJECT_LABEL "RUN_TESTS")
  foreach(NAME ${ARGN})
    list(FIND CMT_PROJECTS ${NAME} I)
    if(I EQUAL -1)
      message(FATAL_ERROR "Failed to locate project definition for ${NAME}")
    endif()
    list(GET CMT_DEFINITIONS ${I} DEFINITION)
    cmt_read_definition(${DEFINITION})

    if(${EP_OPTION_NAME})
      ExternalProject_Get_Property(${EP_NAME} BINARY_DIR)
      add_custom_command(
        COMMENT "Testing '${EP_NAME}'"
        TARGET "test"
        COMMAND ${CMAKE_COMMAND}
          -DLAUNCHER:FILEPATH=${PROJECT_BINARY_DIR}/${PROJECT_NAME}.cmake
          -DINTDIR:STRING=${CMAKE_CFG_INTDIR}
          -DBINARY_DIR:PATH=${BINARY_DIR}
          -P ${CMT_CMAKE_DIR}/TestProject.cmake
        WORKING_DIRECTORY ${BINARY_DIR})
    endif()
  endforeach()
endfunction()


# -----------------------------------------------------------------------------
#! Touch projects (retrigger execution of an external project's steps), if marked accordingly.
function(cmt_touch_projects)
  foreach(NAME ${ARGN})
    list(FIND CMT_PROJECTS ${NAME} I)
    if(I EQUAL -1)
      message(FATAL_ERROR "Failed to locate project definition for ${NAME}")
    endif()
    list(GET CMT_DEFINITIONS ${I} DEFINITION)
    cmt_read_definition(${DEFINITION})

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


# -----------------------------------------------------------------------------
#! Verify existence of an executable via successful execution of provided command.
function(cmt_verify_executable)
  execute_process(
    COMMAND ${ARGN}
    RESULT_VARIABLE RESULT
    OUTPUT_QUIET)
  if(NOT RESULT MATCHES "^-?[01]$")
    message(FATAL_ERROR "Failed to find '${ARGV0}' in PATH")
  endif()
endfunction()
