//===-- PassBase.td - Base PCL pass definition file ------=-*- tablegen -*-===//
//
// Part of the PCL Project, under the Apache License v2.0.
// See LICENSE.txt for license information.
// Copyright 2025 Veridise Inc.
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

#ifndef PCL_PASS_PASSBASE
#define PCL_PASS_PASSBASE

include "mlir/Pass/PassBase.td"

class PCLPass<string passArg, string operation = "::mlir::ModuleOp">
    : Pass<passArg, operation> {
  let dependentDialects = [
      // clang-format off
      "pcl::PCLDialect",
      "mlir::func::FuncDialect",
      // clang-format on
  ];
}

#endif // PCL_PASS_PASSBASE
