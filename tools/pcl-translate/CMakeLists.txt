add_executable(pcl-translate pcl-translate.cpp)

pcl_target_add_mlir_link_settings(pcl-translate)
set_target_properties(pcl-translate PROPERTIES RUNTIME_OUTPUT_DIRECTORY
                                          ${CMAKE_BINARY_DIR}/bin)
target_link_libraries(pcl-translate
  PRIVATE
  PCLDialect
  PCLTransforms
  MLIRFuncDialect
  MLIRIR
  MLIRParser
  MLIROptLib
  MLIRPass
  MLIRTransforms
  MLIRTranslateLib
  LLVMHeaders
  MLIRHeaders
)