add_library(PCLTransforms)
add_library(PCL::PCLTransforms ALIAS PCLTransforms)

file(GLOB PCLTransforms_SOURCES "*.cpp")
target_sources(PCLTransforms PRIVATE ${PCLTransforms_SOURCES})
target_link_libraries(
  PCLTransforms PUBLIC PCLDialectHeaders MLIRIR
                     MLIRPass MLIRParser MLIRTransformUtils MLIRTransformUtils
                     LLVMHeaders MLIRHeaders
                     PCLDialect)
add_dependencies(PCLTransforms PCLDialect PCLDialectHeaders)
pcl_target_add_mlir_link_settings(PCLTransforms)

install(TARGETS PCLTransforms EXPORT PCLTargets)