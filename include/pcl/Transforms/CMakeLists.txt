include_directories(${MLIR_INCLUDE_DIRS} ${PCL_INCLUDE_DIR})

set(LLVM_TARGET_DEFINITIONS "PCLTransformationPasses.td")
mlir_tablegen(PCLTransformationPasses.h.inc -gen-pass-decls -name=Transformation)
mlir_tablegen(PCLTransformationPasses.capi.h.inc -gen-pass-capi-header --prefix PCLTransformation)
mlir_tablegen(PCLTransformationPasses.capi.cpp.inc -gen-pass-capi-impl --prefix PCLTransformation)

add_public_tablegen_target(PCLTransformationIncGen)
add_dependencies(mlir-headers PCLTransformationIncGen)
add_dependencies(PCLDialectHeaders PCLTransformationIncGen)
