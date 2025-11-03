#ifndef PCL_TYPES
#define PCL_TYPES

include "pcl/Dialect/IR/Dialect.td"
include "mlir/IR/OpBase.td"

class PCL_Type<string name, string storage> : TypeDef<PCLDialect, name> {
  let mnemonic = storage;
}

def PCL_FieldType : PCL_Type<"Felt", "felt">{
  let summary = "Finite field element";
}

def PCL_BoolType : PCL_Type<"Bool", "bool"> {
  let summary = "Boolean in {0,1}";
}

#endif // PCL_TYPES