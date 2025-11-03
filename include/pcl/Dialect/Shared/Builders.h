//===-- Builders.h ----------------------------------------------*- C++ -*-===//
//
// Part of the PCL Project, under the Apache License v2.0.
// See LICENSE.txt for license information.
// Copyright 2025 Veridise Inc.
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

#include "pcl/Dialect/IR/Dialect.h"
#include "pcl/Utils/Constants.h"

#include <mlir/IR/Attributes.h>
#include <mlir/IR/Builders.h>
#include <mlir/IR/Location.h>
#include <mlir/IR/MLIRContext.h>
#include <mlir/IR/OwningOpRef.h>

#define GET_OP_CLASSES
#include "mlir/IR/BuiltinOps.h.inc"

namespace pcl {

inline mlir::Location getUnknownLoc(mlir::MLIRContext *context) {
  return mlir::UnknownLoc::get(context);
}

mlir::ModuleOp createPCLModule(mlir::MLIRContext *context, mlir::Location loc) {
  auto mod = mlir::ModuleOp::create(loc);
  addLangAttrForPCLDialect(mod);
  return mod;
}

void addLangAttrForPCLDialect(mlir::ModuleOp mod) {
  mlir::MLIRContext *ctx = mod.getContext();
  if (auto dialect = ctx->getOrLoadDialect<PCLDialect>()) {
    mod->setAttr(LANG_ATTR_NAME, mlir::StringAttr::get(ctx, dialect->getNamespace()));
  } else {
    llvm::report_fatal_error("Could not load PCL dialect!");
  }
}

inline mlir::OwningOpRef<mlir::ModuleOp> createLLZKModule(mlir::MLIRContext *context) {
  return createPCLModule(context, getUnknownLoc(context));
}

} // namespace pcl
