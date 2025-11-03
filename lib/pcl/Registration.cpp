//===-- Registration.cpp - Register R1CS dialect ---------------*- C++ -*--===//
//
// Part of the LLZK Project, under the Apache License v2.0.
// See LICENSE.txt for license information.
// Copyright 2025 Veridise Inc.
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

#include "pcl/Dialect/IR/Dialect.h"
#include "pcl/InitAllDialects.h"

#include <mlir/Dialect/Func/IR/FuncOps.h>
#include <mlir/IR/DialectRegistry.h>

namespace pcl {
void registerAllDialects(mlir::DialectRegistry &registry) {
  registry.insert<mlir::func::FuncDialect, PCLDialect>();
}
} // namespace pcl
