# Refresh metadata before Flutter copies assets, including for plain
# `flutter run` / `flutter build` in an existing Windows checkout.
get_directory_property(AIVA_FLUTTER_ROOT
  DIRECTORY "${FLUTTER_MANAGED_DIR}" DEFINITION FLUTTER_ROOT)
get_filename_component(AIVA_PROJECT_ROOT "${CMAKE_CURRENT_LIST_DIR}/.." ABSOLUTE)
set(AIVA_DART "${AIVA_FLUTTER_ROOT}/bin/cache/dart-sdk/bin/dart")
if(CMAKE_HOST_WIN32)
  string(APPEND AIVA_DART ".exe")
endif()

add_custom_target(aiva_content_index
  COMMAND "${AIVA_DART}" "${AIVA_PROJECT_ROOT}/tool/content_index.dart"
  WORKING_DIRECTORY "${AIVA_PROJECT_ROOT}"
  COMMENT "Refreshing Aiva course index before bundling assets"
  VERBATIM
)
add_dependencies(flutter_assemble aiva_content_index)
