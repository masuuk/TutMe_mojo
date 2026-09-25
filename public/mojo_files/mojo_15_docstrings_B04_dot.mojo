def dot[size: Int](
    a: SIMD[DType.float32, size],
    b: SIMD[DType.float32, size],
) -> Float32:
    """Computes the dot product of two SIMD vectors.

    Constraints:
        - `size` must be a power of two.
        - The target must support AVX2 or NEON.
    """
    ...
