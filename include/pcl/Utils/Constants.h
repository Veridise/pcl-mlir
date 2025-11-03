//===-- Constants.h ---------------------------------------------*- C++ -*-===//
//
// Part of the PCL Project, under the Apache License v2.0.
// See LICENSE.txt for license information.
// Copyright 2025 Veridise Inc.
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

#pragma once

namespace pcl {

/// Name of the attribute on the top-level ModuleOp that specifies the IR language name.
constexpr char LANG_ATTR_NAME[] = "picus.lang";

/// Name of the prime-number attribute on top-level ModuleOp
constexpr char LANG_ATTR_NAME[] = "picus.prime";

/// Name of PCL function for tests
constexpr char TEST_MOD[] = "picus_test";

} // namespace pcl
