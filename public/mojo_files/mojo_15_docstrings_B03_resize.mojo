def resize[dtype: DType](
    data: List[Scalar[dtype]],
    size: Int,
    fill: Scalar[dtype] = 0,
) raises -> List[Scalar[dtype]]:
    """Resizes a list by truncating it or padding it with a fill value.

    Parameters:
        dtype: The element type of the list.

    Args:
        data: The source list to resize.
        size: The target length.
        fill: The value used to pad the list when growing it.

    Returns:
        A new list with length `size`.

    Raises:
        An error if `size` is less than or equal to zero.
    """
    ...
