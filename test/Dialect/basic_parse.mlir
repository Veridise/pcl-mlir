// RUN: pcl-opt %s 2>&1 | FileCheck --enable-var-scope %s

module attributes {pcl.lang = "pcl", pcl.prime = "<-1>"} {
  func.func @Foo(%arg0 : !pcl.felt, %arg1: !pcl.felt) -> (!pcl.felt) {
    %0 = pcl.add %arg0, %arg1 : !pcl.felt
    return %0 : !pcl.felt
  }
}
