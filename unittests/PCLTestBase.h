//===-- PCLTestBase.h -------------------------------------------*- C++ -*-===//
//
// Part of the PCL Project, under the Apache License v2.0.
// See LICENSE.txt for license information.
// Copyright 2025 Veridise Inc.
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

#pragma once

#include "pcl/InitAllDialects.h"

#include <mlir/IR/Location.h>
#include <mlir/IR/MLIRContext.h>

#include <gtest/gtest.h>

class PCLTest : public ::testing::Test {
protected:
  mlir::MLIRContext ctx;
  mlir::Location loc;

  PCLTest() : ctx(), loc(mlir::UnknownLoc::get(ctx)) {
    mlir::DialectRegistry registry;
    pcl::registerAllDialects(registry);
    ctx.appendDialectRegistry(registry);
    ctx.loadAllAvailableDialects();
  }
};
