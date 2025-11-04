//===-- pcl-translate.cpp ---------------------------------------------*- C++ -*-===//
//
// Part of the PCL Project, under the Apache License v2.0.
// See LICENSE.txt for license information.
// Copyright 2025 Veridise Inc.
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

#include "pcl/Dialect/IR/Attrs.h"
#include "pcl/Dialect/IR/Dialect.h"
#include "pcl/Dialect/IR/Ops.h"
#include "pcl/Export/Printer.h"

#include <mlir/InitAllDialects.h>
#include <mlir/Tools/mlir-translate/MlirTranslateMain.h>
#include <mlir/Tools/mlir-translate/Translation.h>

using namespace mlir;

// Registration with mlir-translate
static TranslateFromMLIRRegistration regExportPCL(
    "export-pcl", "Export PCL-MLIR module to PCL Lisp format", [](ModuleOp m, raw_ostream &os) {
      return pcl::exportPCL(m, os);
    }, [](DialectRegistry &r) { r.insert<pcl::PCLDialect, func::FuncDialect>(); }
);

int main(int argc, char **argv) {
  return failed(mlir::mlirTranslateMain(argc, argv, "PCL translator"));
}
