def clamp(val: Int, low: Int, high: Int) -> Int:
    """Clamp val to [low, high] using MLIR comparisons and select."""
    var v = val.__mlir_index__()
    var lo = low.__mlir_index__()
    var hi = high.__mlir_index__()

    # index.cmp returns i1, but pop.select needs !kgen.scalar<bool>
    var too_low = __mlir_op.`pop.cast_from_builtin`[
        _type=__mlir_type.`!kgen.scalar<bool>`](
        __mlir_op.`index.cmp`[pred=__mlir_attr.`#index<cmp_predicate slt>`](v, lo))
    var result = __mlir_op.`pop.select`(too_low, lo, v)

    var too_high = __mlir_op.`pop.cast_from_builtin`[
        _type=__mlir_type.`!kgen.scalar<bool>`](
        __mlir_op.`index.cmp`[pred=__mlir_attr.`#index<cmp_predicate sgt>`](result, hi))
    result = __mlir_op.`pop.select`(too_high, hi, result)
    return Int(mlir_value=result)

def main():
    print(clamp(15, 0, 10))   # 10
    print(clamp(-5, 0, 10))   # 0
    print(clamp(7, 0, 10))    # 7
