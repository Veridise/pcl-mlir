// RUN: pcl-opt -split-input-file -verify-diagnostics %s

// Error: prime cannot be a negative number
// expected-error@+1 {{prime must be positive}}
module attributes {pcl.lang = "pcl", pcl.prime = #pcl.prime<-1>} {
}

// -----

module attributes {pcl.lang = "pcl", pcl.prime = #pcl.prime<7>} {
  // expected-error@+1 {{op failed to verify that must be inside a func.func}}
  %arg0 = pcl.const 1: i64
}