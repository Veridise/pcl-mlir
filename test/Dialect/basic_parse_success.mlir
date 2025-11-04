// RUN: pcl-opt -split-input-file %s 2>&1 | FileCheck --enable-var-scope %s

// basic test which returns a value. No constraints emitted
module attributes {pcl.lang = "pcl", pcl.prime = #pcl.prime<7>} {
  func.func @Foo(%arg0 : !pcl.felt, %arg1: !pcl.felt) -> (!pcl.felt) {
    %var = pcl.var "out" true
    return %var : !pcl.felt
  }
}

// CHECK-LABEL:   func.func @Foo(
// CHECK-SAME:                   %[[VAL_0:.*]]: !pcl.felt,
// CHECK-SAME:                   %[[VAL_1:.*]]: !pcl.felt) -> !pcl.felt {
// CHECK:           %[[VAL_2:.*]] = pcl.var "out" true
// CHECK:           return %[[VAL_2]] : !pcl.felt
// CHECK:         }
// -----


// basic test which adds and returns a value and constrains the result to be less than 1
module attributes {pcl.lang = "pcl", pcl.prime = #pcl.prime<7>} {
  func.func @Foo(%arg0 : !pcl.felt, %arg1: !pcl.felt) -> (!pcl.felt) {
    %var = pcl.var "out" true
    %0 = pcl.add %arg0, %arg1
    %1 = pcl.eq %var, %0
    pcl.assert %1
    %2 = pcl.const 1 : i64
    %3 = pcl.lt %var, %2
    pcl.assert %3
    pcl.return %var : !pcl.felt
  }
}

// CHECK-LABEL:   func.func @Foo(
// CHECK-SAME:                   %[[VAL_0:.*]]: !pcl.felt,
// CHECK-SAME:                   %[[VAL_1:.*]]: !pcl.felt) -> !pcl.felt {
// CHECK:           %[[VAL_2:.*]] = pcl.var "out" true
// CHECK:           %[[VAL_3:.*]] = pcl.add %[[VAL_0]], %[[VAL_1]]
// CHECK:           %[[VAL_4:.*]] = pcl.eq %[[VAL_2]], %[[VAL_3]]
// CHECK:           pcl.assert %[[VAL_4]]
// CHECK:           %[[VAL_5:.*]] = pcl.const  1 : i64
// CHECK:           %[[VAL_6:.*]] = pcl.lt %[[VAL_2]], %[[VAL_5]]
// CHECK:           pcl.assert %[[VAL_6]]
// CHECK:           pcl.return %[[VAL_2]] : !pcl.felt
// CHECK:         }
