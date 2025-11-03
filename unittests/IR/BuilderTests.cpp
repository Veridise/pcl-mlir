//===-- BuildersTests.cpp - Unit tests for op builders ----------*- C++ -*-===//
//
// Part of the PCL Project, under the Apache License v2.0.
// See LICENSE.txt for license information.
// Copyright 2025 Veridise Inc.
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

#include "pcl/Dialect/Shared/Builders.h"

#include <gtest/gtest.h>

#include "../PCLTestBase.h"

/* Tests for the ModuleBuilder */

using namespace pcl;

/// TODO: likely a good candidate for property-based testing.
/// A potential good option for a future date: https://github.com/emil-e/rapidcheck
class ModuleBuilderTests : public PCLTest {
protected:
  mlir::OwningOpRef<mlir::ModuleOp> mod;

  ModuleBuilderTests() : PCLTest(), mod(createPCLModule(&ctx)) {}

  void SetUp() override {
    // Create a new module and builder for each test.
    mod = createPCLModule(&ctx);
  }
};
