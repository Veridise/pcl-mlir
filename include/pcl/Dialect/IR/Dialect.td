//===-- Dialect.td -----------------------------------------*- tablegen -*-===//
//
// Part of the PCL Project, under the Apache License v2.0.
// See LICENSE.txt for license information.
// Copyright 2025 Veridise Inc.
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

#ifndef PCL_DIALECT
#define PCL_DIALECT

include "mlir/IR/DialectBase.td"

def PCLDialect : Dialect {
  let name = "pcl";
  let summary = "PCL";
  let cppNamespace = "::pcl";
  let usePropertiesForAttributes = 0;
  let useDefaultTypePrinterParser = true;
  let useDefaultAttributePrinterParser = true;

  let extraClassDeclaration = [{
    ::mlir::LogicalResult verifyOperationAttribute(::mlir::Operation *op,
                                                   ::mlir::NamedAttribute attr) override;
  }];
}

#endif // PCL_DIALECT