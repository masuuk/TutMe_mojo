# Mojo while loop for control flow, MLIR for the computation inside
def sum_to(end: Int) -> Int:
    var acc: __mlir_type.index = __mlir_attr.`0 : index`
    var i: __mlir_type.index = __mlir_attr.`0 : index`
    var one: __mlir_type.index = __mlir_attr.`1 : index`

    while Bool(__mlir_op.`index.cmp`[
        pred=__mlir_attr.`#index<cmp_predicate slt>`](i, end.__mlir_index__())):
        acc = __mlir_op.`index.add`(acc, i)
        i = __mlir_op.`index.add`(i, one)

    return Int(mlir_value=acc)

def main():
    print(sum_to(10))   # 45
