var x: __mlir_type.i1                        # 1-bit integer (boolean)
var y: __mlir_type.index                     # Machine-width index
var z: __mlir_type.f64                        # 64-bit float
var a: __mlir_type.`!kgen.none`            # Dialect type with ! prefix
var b: __mlir_type.`!kgen.scalar<f64>`   # Pop dialect scalar

def mlir_types_in_action():
    var flag: __mlir_type.i1 = __mlir_attr.true
    var count: __mlir_type.index = __mlir_attr.`0 : index`
    print(Bool(flag))                    # True
    print(Int(mlir_value=count))       # 0
