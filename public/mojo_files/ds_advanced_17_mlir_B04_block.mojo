# From SIMD: for SIMD[DType.float32, 4] produces: !kgen.simd<4, f32>
comptime _mlir_type = __mlir_type[
    `!kgen.simd<`, Self.size._mlir_value, `,`,
    Self.dtype._mlir_value, `>`]

# Nested substitution: produces complex<i32>
var complex_int: __mlir_type[`complex<`, __mlir_type.i32, `>`]
