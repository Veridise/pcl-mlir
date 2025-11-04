//===-- PCLTransformationPasses.h -------------------------------*- C++ -*-===//
//
// Part of the PCL Project, under the Apache License v2.0.
// See LICENSE.txt for license information.
// Copyright 2025 Veridise Inc.
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

#pragma once

#include "pcl/Pass/PassBase.h"

#include <mlir/IR/BuiltinOps.h>
namespace pcl {

std::unique_ptr<mlir::Pass> createPrintPass();

#define GEN_PASS_REGISTRATION
#include "pcl/Transforms/PCLTransformationPasses.h.inc"

}; // namespace pcl
