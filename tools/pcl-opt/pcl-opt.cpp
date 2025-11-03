//===-- pcl-opt.cpp --------------------------------------------*- C++ -*-===//
//
// Part of the PCL Project, under the Apache License v2.0.
// See LICENSE.txt for license information.
// Copyright 2025 Veridise Inc.
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

#include "pcl/Dialect/IR/Dialect.h"
#include "pcl/InitAllDialects.h"

#include <mlir/IR/DialectRegistry.h>
#include <mlir/IR/MLIRContext.h>
#include <mlir/InitAllDialects.h>
#include <mlir/InitAllPasses.h>
#include <mlir/Tools/mlir-opt/MlirOptMain.h>

#include <llvm/Support/PrettyStackTrace.h>
#include <llvm/Support/Signals.h>

#include "tools/config.h"

int main(int argc, char **argv) {
  llvm::sys::PrintStackTraceOnErrorSignal(llvm::StringRef());
  llvm::setBugReportMsg(
      "PLEASE submit a bug report to " BUG_REPORT_URL
      " and include the crash backtrace, relevant PCL files,"
      " and associated run script(s).\n"
  );

  mlir::DialectRegistry registry;
  pcl::registerAllDialects(registry);

  return mlir::asMainReturnCode(mlir::MlirOptMain(argc, argv, "PCL Optimizer\n", registry));
}