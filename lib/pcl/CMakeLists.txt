add_library(PCLDialect)

file(GLOB_RECURSE PCLDialect_SOURCES "*.cpp")
target_sources(PCLDialect PRIVATE ${PCLDialect_SOURCES})
target_link_libraries(
  PCLDialect PUBLIC PCLDialectHeaders
                     MLIRIR MLIRSupport
                     LLVMHeaders MLIRHeaders)
add_dependencies(PCLDialect PCLDialectIncGen)
pcl_target_add_mlir_link_settings(PCLDialect)

install(TARGETS PCLDialect EXPORT PCLTargets)