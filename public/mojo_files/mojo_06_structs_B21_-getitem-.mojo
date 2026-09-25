def __getitem__(self, span: Slice) -> Self:
    var start: Int
    var end: Int
    var step: Int
    start, end, step = span.indices(self.size)
    ...
