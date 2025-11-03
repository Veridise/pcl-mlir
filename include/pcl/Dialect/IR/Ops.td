//===-- Ops.td -------------------------------------------*--- tablegen -*-===//
//
// Part of the PCL Project, under the Apache License v2.0.
// See LICENSE.txt for license information.
// Copyright 2025 Veridise Inc.
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

#ifndef PCL_OPS
#define PCL_OPS

include "pcl/Dialect/IR/Types.td"
include "pcl/Dialect/IR/Attrs.td"

include "mlir/IR/OpBase.td"
include "mlir/Interfaces/SideEffectInterfaces.td"
include "mlir/Interfaces/InferTypeOpInterface.td"

def InsideFunc
    : PredOpTrait<"must be inside a func.func",
                  CPred<"$_op.getParentOfType<mlir::func::FuncOp>()">>;

class PCL_Op<string mnemonic, list<Trait> traits = []>
    : Op<PCLDialect, mnemonic, traits>;

// -----------------------------------------------------------------------------
// Arithmetic over fields
// -----------------------------------------------------------------------------
def PCL_AddOp : PCL_Op<"add", [Pure, Commutative, SameOperandsAndResultType,
                               InsideFunc]> {
  let summary = "Field addition";
  let arguments = (ins PCL_FieldType:$lhs, PCL_FieldType:$rhs);
  let results = (outs PCL_FieldType:$res);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` type($res)";
}

def PCL_SubOp : PCL_Op<"sub", [Pure, SameOperandsAndResultType, InsideFunc]> {
  let summary = "Field subtraction";
  let arguments = (ins PCL_FieldType:$lhs, PCL_FieldType:$rhs);
  let results = (outs PCL_FieldType:$res);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` type($res)";
}

def PCL_MulOp : PCL_Op<"mul", [Pure, Commutative, SameOperandsAndResultType,
                               InsideFunc]> {
  let summary = "Field multiplication";
  let arguments = (ins PCL_FieldType:$lhs, PCL_FieldType:$rhs);
  let results = (outs PCL_FieldType:$res);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` type($res)";
}

def PCL_NegOp : PCL_Op<"neg", [Pure, SameOperandsAndResultType, InsideFunc]> {
  let summary = "Field negation";
  let arguments = (ins PCL_FieldType:$val);
  let results = (outs PCL_FieldType:$res);
  let assemblyFormat = "$val attr-dict `:` type($res)";
}

// -----------------------------------------------------------------------------
// Comparisons: return !pcl.bool
// -----------------------------------------------------------------------------
class PCLCmpBase<string mnem, string doc> : Op<PCLDialect, mnem, [Pure]> {
  let summary = doc;
  let arguments = (ins PCL_FieldType:$lhs, PCL_FieldType:$rhs);
  let results = (outs PCL_BoolType:$res);
  let assemblyFormat = "$lhs `,` $rhs attr-dict";
}

def PCL_CmpEqOp : PCLCmpBase<"eq", "lhs == rhs (field equality)">;
def PCL_CmpLtOp : PCLCmpBase<"lt", "lhs < rhs (signed/semantic: range)">;
// If you need unsigned semantics, duplicate with a different name or attr.
def PCL_CmpLeOp : PCLCmpBase<"le", "lhs <= rhs">;
def PCL_CmpGtOp : PCLCmpBase<"gt", "lhs > rhs">;
def PCL_CmpGeOp : PCLCmpBase<"ge", "lhs >= rhs">;

// -----------------------------------------------------------------------------
// Boolean connectives on !pcl.bool
// -----------------------------------------------------------------------------
def PCL_AndOp : PCL_Op<"and", [Pure, Commutative, SameOperandsAndResultType]> {
  let summary = "Boolean conjunction (a && b)";
  let arguments = (ins PCL_BoolType:$a, PCL_BoolType:$b);
  let results = (outs PCL_BoolType:$res);
  let assemblyFormat = "$a `,` $b attr-dict";
}

def PCL_OrOp : PCL_Op<"or", [Pure, Commutative, SameOperandsAndResultType]> {
  let summary = "Boolean disjunction (a || b)";
  let arguments = (ins PCL_BoolType:$a, PCL_BoolType:$b);
  let results = (outs PCL_BoolType:$res);
  let assemblyFormat = "$a `,` $b attr-dict";
}

def PCL_NotOp : PCL_Op<"not", [Pure, SameOperandsAndResultType]> {
  let summary = "Boolean negation (!cond)";
  let arguments = (ins PCL_BoolType:$cond);
  let results = (outs PCL_BoolType:$res);
  let assemblyFormat = "$cond attr-dict";
}

def PCL_ImpliesOp : PCL_Op<"implies", [Pure]> {
  let summary = "Boolean implication (a => b)";
  let arguments = (ins PCL_BoolType:$a, PCL_BoolType:$b);
  let results = (outs PCL_BoolType:$res);
  let assemblyFormat = "$a `,` $b attr-dict";
}

def PCL_IffOp : PCL_Op<"iff", [Pure, Commutative]> {
  let summary = "Boolean equivalence (a <=> b)";
  let arguments = (ins PCL_BoolType:$a, PCL_BoolType:$b);
  let results = (outs PCL_BoolType:$res);
  let assemblyFormat = "$a `,` $b attr-dict";
}

def PCL_DetOp : PCL_Op<"det", [Pure]> {
  let summary = "returns true iff $a deterministic";
  let arguments = (ins PCL_FieldType:$a);
  let results = (outs PCL_BoolType:$res);
  let assemblyFormat = "$a attr-dict";
}

// -----------------------------------------------------------------------------
// Assertions & post-conditions (side-effecting)
// -----------------------------------------------------------------------------
def PCL_AssertOp : PCL_Op<"assert", []> {
  let summary = "Assert that a boolean holds";
  let arguments = (ins PCL_BoolType:$cond);
  let assemblyFormat = "$cond attr-dict";
}

def PCL_PostOp : PCL_Op<"post-cond", []> {
  let summary = "Post-condition on function outputs";
  let arguments = (ins PCL_BoolType:$cond);
  let assemblyFormat = "$cond attr-dict";
}

// Keep if you want: assume-deterministic (accept either field or bool)
def PCL_AssumeDeterministicOp : PCL_Op<"assume.deterministic", []> {
  let summary = "Assume the given value is deterministic";
  let arguments = (ins PCL_FieldType:$v);
  let assemblyFormat = "$v attr-dict";
}

#endif // PCL_OPS