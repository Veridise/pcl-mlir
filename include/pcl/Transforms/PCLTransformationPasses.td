//===-- PCLTransformationPasses.td -------------------------*- tablegen -*-===//
//
// Part of the PCL Project, under the Apache License v2.0.
// See LICENSE.txt for license information.
// Copyright 2025 Veridise Inc.
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

#ifndef PCL_TRANSFORMATION_PASSES_TD
#define PCL_TRANSFORMATION_PASSES_TD

include "pcl/Pass/PassBase.td"

def PCLPrintPass
    : PCLPass<"pcl-print-pass"> {
  let summary = "Remove redundant reads and writes";
  let description = [{
    Convert a PCL module into lisp form suitable for Picus.
  }];
  let constructor = "pcl::createPrintPass()";
}

#endif // PCL_TRANSFORMATION_PASSES_TD
