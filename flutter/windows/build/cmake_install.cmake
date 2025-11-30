# Install script for directory: D:/dev/helpdesk-truongit/flutter/windows

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "$<TARGET_FILE_DIR:rustdesk>")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/dev/helpdesk-truongit/flutter/windows/build/flutter/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/dev/helpdesk-truongit/flutter/windows/build/runner/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/dev/helpdesk-truongit/flutter/windows/build/plugins/desktop_drop/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/dev/helpdesk-truongit/flutter/windows/build/plugins/desktop_multi_window/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/dev/helpdesk-truongit/flutter/windows/build/plugins/file_selector_windows/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/dev/helpdesk-truongit/flutter/windows/build/plugins/flutter_custom_cursor/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/dev/helpdesk-truongit/flutter/windows/build/plugins/flutter_gpu_texture_renderer/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/dev/helpdesk-truongit/flutter/windows/build/plugins/screen_retriever/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/dev/helpdesk-truongit/flutter/windows/build/plugins/texture_rgba_renderer/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/dev/helpdesk-truongit/flutter/windows/build/plugins/uni_links_desktop/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/dev/helpdesk-truongit/flutter/windows/build/plugins/url_launcher_windows/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/dev/helpdesk-truongit/flutter/windows/build/plugins/window_manager/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/dev/helpdesk-truongit/flutter/windows/build/plugins/window_size/cmake_install.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Debug/rustdesk.exe")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Debug" TYPE EXECUTABLE FILES "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Debug/rustdesk.exe")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Pp][Rr][Oo][Ff][Ii][Ll][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Profile/rustdesk.exe")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Profile" TYPE EXECUTABLE FILES "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Profile/rustdesk.exe")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Release/rustdesk.exe")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Release" TYPE EXECUTABLE FILES "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Release/rustdesk.exe")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Debug/data/icudtl.dat")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Debug/data" TYPE FILE FILES "D:/dev/helpdesk-truongit/flutter/windows/flutter/ephemeral/icudtl.dat")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Pp][Rr][Oo][Ff][Ii][Ll][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Profile/data/icudtl.dat")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Profile/data" TYPE FILE FILES "D:/dev/helpdesk-truongit/flutter/windows/flutter/ephemeral/icudtl.dat")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Release/data/icudtl.dat")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Release/data" TYPE FILE FILES "D:/dev/helpdesk-truongit/flutter/windows/flutter/ephemeral/icudtl.dat")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Debug/flutter_windows.dll")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Debug" TYPE FILE FILES "D:/dev/helpdesk-truongit/flutter/windows/flutter/ephemeral/flutter_windows.dll")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Pp][Rr][Oo][Ff][Ii][Ll][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Profile/flutter_windows.dll")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Profile" TYPE FILE FILES "D:/dev/helpdesk-truongit/flutter/windows/flutter/ephemeral/flutter_windows.dll")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Release/flutter_windows.dll")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Release" TYPE FILE FILES "D:/dev/helpdesk-truongit/flutter/windows/flutter/ephemeral/flutter_windows.dll")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Debug/desktop_drop_plugin.dll;D:/dev/helpdesk-truongit/flutter/windows/build/runner/Debug/desktop_multi_window_plugin.dll;D:/dev/helpdesk-truongit/flutter/windows/build/runner/Debug/file_selector_windows_plugin.dll;D:/dev/helpdesk-truongit/flutter/windows/build/runner/Debug/flutter_custom_cursor_plugin.dll;D:/dev/helpdesk-truongit/flutter/windows/build/runner/Debug/flutter_gpu_texture_renderer_plugin.dll;D:/dev/helpdesk-truongit/flutter/windows/build/runner/Debug/screen_retriever_plugin.dll;D:/dev/helpdesk-truongit/flutter/windows/build/runner/Debug/texture_rgba_renderer_plugin.dll;D:/dev/helpdesk-truongit/flutter/windows/build/runner/Debug/uni_links_desktop_plugin.dll;D:/dev/helpdesk-truongit/flutter/windows/build/runner/Debug/url_launcher_windows_plugin.dll;D:/dev/helpdesk-truongit/flutter/windows/build/runner/Debug/window_manager_plugin.dll;D:/dev/helpdesk-truongit/flutter/windows/build/runner/Debug/window_size_plugin.dll")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Debug" TYPE FILE FILES
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/desktop_drop/Debug/desktop_drop_plugin.dll"
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/desktop_multi_window/Debug/desktop_multi_window_plugin.dll"
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/file_selector_windows/Debug/file_selector_windows_plugin.dll"
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/flutter_custom_cursor/Debug/flutter_custom_cursor_plugin.dll"
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/flutter_gpu_texture_renderer/Debug/flutter_gpu_texture_renderer_plugin.dll"
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/screen_retriever/Debug/screen_retriever_plugin.dll"
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/texture_rgba_renderer/Debug/texture_rgba_renderer_plugin.dll"
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/uni_links_desktop/Debug/uni_links_desktop_plugin.dll"
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/url_launcher_windows/Debug/url_launcher_windows_plugin.dll"
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/window_manager/Debug/window_manager_plugin.dll"
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/window_size/Debug/window_size_plugin.dll"
      )
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Pp][Rr][Oo][Ff][Ii][Ll][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Profile/desktop_drop_plugin.dll;D:/dev/helpdesk-truongit/flutter/windows/build/runner/Profile/desktop_multi_window_plugin.dll;D:/dev/helpdesk-truongit/flutter/windows/build/runner/Profile/file_selector_windows_plugin.dll;D:/dev/helpdesk-truongit/flutter/windows/build/runner/Profile/flutter_custom_cursor_plugin.dll;D:/dev/helpdesk-truongit/flutter/windows/build/runner/Profile/flutter_gpu_texture_renderer_plugin.dll;D:/dev/helpdesk-truongit/flutter/windows/build/runner/Profile/screen_retriever_plugin.dll;D:/dev/helpdesk-truongit/flutter/windows/build/runner/Profile/texture_rgba_renderer_plugin.dll;D:/dev/helpdesk-truongit/flutter/windows/build/runner/Profile/uni_links_desktop_plugin.dll;D:/dev/helpdesk-truongit/flutter/windows/build/runner/Profile/url_launcher_windows_plugin.dll;D:/dev/helpdesk-truongit/flutter/windows/build/runner/Profile/window_manager_plugin.dll;D:/dev/helpdesk-truongit/flutter/windows/build/runner/Profile/window_size_plugin.dll")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Profile" TYPE FILE FILES
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/desktop_drop/Profile/desktop_drop_plugin.dll"
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/desktop_multi_window/Profile/desktop_multi_window_plugin.dll"
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/file_selector_windows/Profile/file_selector_windows_plugin.dll"
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/flutter_custom_cursor/Profile/flutter_custom_cursor_plugin.dll"
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/flutter_gpu_texture_renderer/Profile/flutter_gpu_texture_renderer_plugin.dll"
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/screen_retriever/Profile/screen_retriever_plugin.dll"
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/texture_rgba_renderer/Profile/texture_rgba_renderer_plugin.dll"
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/uni_links_desktop/Profile/uni_links_desktop_plugin.dll"
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/url_launcher_windows/Profile/url_launcher_windows_plugin.dll"
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/window_manager/Profile/window_manager_plugin.dll"
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/window_size/Profile/window_size_plugin.dll"
      )
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Release/desktop_drop_plugin.dll;D:/dev/helpdesk-truongit/flutter/windows/build/runner/Release/desktop_multi_window_plugin.dll;D:/dev/helpdesk-truongit/flutter/windows/build/runner/Release/file_selector_windows_plugin.dll;D:/dev/helpdesk-truongit/flutter/windows/build/runner/Release/flutter_custom_cursor_plugin.dll;D:/dev/helpdesk-truongit/flutter/windows/build/runner/Release/flutter_gpu_texture_renderer_plugin.dll;D:/dev/helpdesk-truongit/flutter/windows/build/runner/Release/screen_retriever_plugin.dll;D:/dev/helpdesk-truongit/flutter/windows/build/runner/Release/texture_rgba_renderer_plugin.dll;D:/dev/helpdesk-truongit/flutter/windows/build/runner/Release/uni_links_desktop_plugin.dll;D:/dev/helpdesk-truongit/flutter/windows/build/runner/Release/url_launcher_windows_plugin.dll;D:/dev/helpdesk-truongit/flutter/windows/build/runner/Release/window_manager_plugin.dll;D:/dev/helpdesk-truongit/flutter/windows/build/runner/Release/window_size_plugin.dll")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Release" TYPE FILE FILES
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/desktop_drop/Release/desktop_drop_plugin.dll"
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/desktop_multi_window/Release/desktop_multi_window_plugin.dll"
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/file_selector_windows/Release/file_selector_windows_plugin.dll"
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/flutter_custom_cursor/Release/flutter_custom_cursor_plugin.dll"
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/flutter_gpu_texture_renderer/Release/flutter_gpu_texture_renderer_plugin.dll"
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/screen_retriever/Release/screen_retriever_plugin.dll"
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/texture_rgba_renderer/Release/texture_rgba_renderer_plugin.dll"
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/uni_links_desktop/Release/uni_links_desktop_plugin.dll"
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/url_launcher_windows/Release/url_launcher_windows_plugin.dll"
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/window_manager/Release/window_manager_plugin.dll"
      "D:/dev/helpdesk-truongit/flutter/windows/build/plugins/window_size/Release/window_size_plugin.dll"
      )
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Debug/librustdesk.dll")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Debug" TYPE FILE RENAME "librustdesk.dll" FILES "D:/dev/helpdesk-truongit/flutter/windows/../../target/debug/librustdesk.dll")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Pp][Rr][Oo][Ff][Ii][Ll][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Profile/librustdesk.dll")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Profile" TYPE FILE RENAME "librustdesk.dll" FILES "D:/dev/helpdesk-truongit/flutter/windows/../../target/release/librustdesk.dll")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Release/librustdesk.dll")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Release" TYPE FILE RENAME "librustdesk.dll" FILES "D:/dev/helpdesk-truongit/flutter/windows/../../target/release/librustdesk.dll")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    
  file(REMOVE_RECURSE "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Debug/data/flutter_assets")
  
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Pp][Rr][Oo][Ff][Ii][Ll][Ee])$")
    
  file(REMOVE_RECURSE "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Profile/data/flutter_assets")
  
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    
  file(REMOVE_RECURSE "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Release/data/flutter_assets")
  
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Debug/data/flutter_assets")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Debug/data" TYPE DIRECTORY FILES "D:/dev/helpdesk-truongit/flutter/build//flutter_assets")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Pp][Rr][Oo][Ff][Ii][Ll][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Profile/data/flutter_assets")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Profile/data" TYPE DIRECTORY FILES "D:/dev/helpdesk-truongit/flutter/build//flutter_assets")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Release/data/flutter_assets")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Release/data" TYPE DIRECTORY FILES "D:/dev/helpdesk-truongit/flutter/build//flutter_assets")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Pp][Rr][Oo][Ff][Ii][Ll][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Profile/data/app.so")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Profile/data" TYPE FILE FILES "D:/dev/helpdesk-truongit/flutter/build/windows/app.so")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Release/data/app.so")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/dev/helpdesk-truongit/flutter/windows/build/runner/Release/data" TYPE FILE FILES "D:/dev/helpdesk-truongit/flutter/build/windows/app.so")
  endif()
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "D:/dev/helpdesk-truongit/flutter/windows/build/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
if(CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_COMPONENT MATCHES "^[a-zA-Z0-9_.+-]+$")
    set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
  else()
    string(MD5 CMAKE_INST_COMP_HASH "${CMAKE_INSTALL_COMPONENT}")
    set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INST_COMP_HASH}.txt")
    unset(CMAKE_INST_COMP_HASH)
  endif()
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "D:/dev/helpdesk-truongit/flutter/windows/build/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
