macro(pcl_target_add_mlir_link_settings target)
  llvm_update_compile_flags(${target})
  mlir_check_all_link_libraries(${target})
endmacro()
