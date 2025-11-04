//===-- Ops.cpp - PCL dialect implementation ----------------*- C++ -*-----===//
//
// Part of the PCL Project, under the Apache License v2.0.
// See LICENSE.txt for license information.
// Copyright 2025 Veridise Inc.
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

#include "pcl/Dialect/IR/Ops.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"

// TableGen'd implementation files
#define GET_OP_CLASSES
#include "pcl/Dialect/IR/Ops.cpp.inc"
using namespace mlir;
namespace pcl {

LogicalResult ReturnOp::verify() {
  for (mlir::Value v : getVals()) {
    Operation *def = v.getDefiningOp();
    auto var = llvm::dyn_cast_or_null<pcl::VarOp>(def);
    if (!var || !var.getIsOutput()) {
      return emitOpError() << "all return values must be defined by output variables";
    }
  }
  return mlir::success();
}

} // namespace pcl
