add_executable(pcl-opt pcl-opt.cpp)

pcl_target_add_mlir_link_settings(pcl-opt)
set_target_properties(pcl-opt PROPERTIES RUNTIME_OUTPUT_DIRECTORY
                                          ${CMAKE_BINARY_DIR}/bin)
target_link_libraries(pcl-opt
  PRIVATE
  LLVMHeaders
  MLIRHeaders
  MLIRFuncDialect
  MLIRIR
  MLIRParser
  MLIROptLib
  MLIRPass
  MLIRTransforms
  PCLDialect
  PCLTransforms
)