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
