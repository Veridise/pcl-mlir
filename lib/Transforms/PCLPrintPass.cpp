//===-- PCLPrintPass.cpp ----------------------------------------*- C++ -*-===//
//
// Part of the LLZK Project, under the Apache License v2.0.
// See LICENSE.txt for license information.
// Copyright 2025 Veridise Inc.
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//
///
/// \file
/// This file implements the `-pcl-print-pass` pass.
///
//===----------------------------------------------------------------------===//

#include "pcl/Dialect/IR/Dialect.h"
#include "pcl/Export/Printer.h"
#include "pcl/Transforms/PCLTransformationPasses.h"

#include <mlir/IR/BuiltinOps.h>

#include <llvm/ADT/DenseMap.h>
#include <llvm/ADT/DenseMapInfo.h>
#include <llvm/ADT/SmallVector.h>
#include <llvm/Support/Debug.h>

#include <deque>
#include <memory>

// Include the generated base pass class definitions.
namespace pcl {
#define GEN_PASS_DEF_PCLPRINTPASS
#include "pcl/Transforms/PCLTransformationPasses.h.inc"
} // namespace pcl

using namespace mlir;
using namespace pcl;

#define DEBUG_TYPE "pcl-printing"

namespace {

class PCLPrintPass : public pcl::impl::PCLPrintPassBase<PCLPrintPass> {

  void getDependentDialects(mlir::DialectRegistry &registry) const override {
    registry.insert<func::FuncDialect>();
  }

  void runOnOperation() override {
    ModuleOp moduleOp = getOperation();
    assert(
        moduleOp->getContext()->getLoadedDialect<func::FuncDialect>() && "Func dialect not loaded"
    );
    if (failed(exportPCL(moduleOp, llvm::outs()))) {
      signalPassFailure();
    }
  }
};
} // namespace

std::unique_ptr<mlir::Pass> pcl::createPrintPass() { return std::make_unique<PCLPrintPass>(); }
