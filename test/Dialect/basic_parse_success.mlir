// RUN: pcl-opt %s 2>&1 | FileCheck --enable-var-scope %s

// basic test which adds and returns a value
module attributes {pcl.lang = "pcl", pcl.prime = #pcl.prime<7>} {
  func.func @Foo(%arg0 : !pcl.felt, %arg1: !pcl.felt) -> (!pcl.felt) {
    %0 = pcl.add %arg0, %arg1
    return %0 : !pcl.felt
  }
}

// CHECK-LABEL:   module attributes {pcl.lang = "pcl", pcl.prime = #pcl.prime<7 : i64>} {
// CHECK:           func.func @Foo(%[[VAL_0:.*]]: !pcl.felt, %[[VAL_1:.*]]: !pcl.felt) -> !pcl.felt {
// CHECK:             %[[VAL_2:.*]] = pcl.add %[[VAL_0]], %[[VAL_1]]
// CHECK:             return %[[VAL_2]] : !pcl.felt
// CHECK:           }
// CHECK:         }
// -----


// basic test which adds and returns a value and constrains the result to be 1
module attributes {pcl.lang = "pcl", pcl.prime = #pcl.prime<7>} {
  func.func @Foo(%arg0 : !pcl.felt, %arg1: !pcl.felt) -> (!pcl.felt) {
    %0 = pcl.add %arg0, %arg1
    %1 = pcl.const 1 : i64
    %2 = pcl.eq %0, %1
    return %0 : !pcl.felt
  }
}

// CHECK-LABEL:   module attributes {pcl.lang = "pcl", pcl.prime = #pcl.prime<7 : i64>} {
// CHECK:           func.func @Foo(%[[VAL_0:.*]]: !pcl.felt, %[[VAL_1:.*]]: !pcl.felt) -> !pcl.felt {
// CHECK:             %[[VAL_2:.*]] = pcl.add %[[VAL_0]], %[[VAL_1]]
// CHECK:             %[[VAL_3:.*]] = pcl.const  1 : i64
// CHECK:             %[[VAL_4:.*]] = pcl.eq %[[VAL_2]], %[[VAL_3]]
// CHECK:             return %[[VAL_2]] : !pcl.felt
// CHECK:           }
// CHECK:         }
// -----


// basic test which adds and returns a value and constrains the result to be less than 1
module attributes {pcl.lang = "pcl", pcl.prime = #pcl.prime<7>} {
  func.func @Foo(%arg0 : !pcl.felt, %arg1: !pcl.felt) -> (!pcl.felt) {
    %0 = pcl.add %arg0, %arg1
    %1 = pcl.const 1 : i64
    %2 = pcl.lt %0, %1
    return %0 : !pcl.felt
  }
}

// CHECK-LABEL:   module attributes {pcl.lang = "pcl", pcl.prime = #pcl.prime<7 : i64>} {
// CHECK:           func.func @Foo(%[[VAL_0:.*]]: !pcl.felt, %[[VAL_1:.*]]: !pcl.felt) -> !pcl.felt {
// CHECK:             %[[VAL_2:.*]] = pcl.add %[[VAL_0]], %[[VAL_1]]
// CHECK:             %[[VAL_3:.*]] = pcl.const  1 : i64
// CHECK:             %[[VAL_4:.*]] = pcl.lt %[[VAL_2]], %[[VAL_3]]
// CHECK:             return %[[VAL_2]] : !pcl.felt
// CHECK:           }
// CHECK:         }
// -----
