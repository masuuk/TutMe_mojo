def median(self) -> Float64:
    # copy the data first so the original stays untouched
    var s: List[Float64] = []
    for x in self.data:
        s.append(x)

    # a simple selection sort — swaps the smallest value into place
    var n = len(s)
    for i in range(n):
        var smallest = i
        for j in range(i, n):
            if s[j] < s[smallest]:
                smallest = j
        if smallest != i:
            var tmp = s[i]
            s[i] = s[smallest]
            s[smallest] = tmp

    var mid = n >> 1
    if n % 2 == 1:
        return s[mid]
    return (s[mid - 1] + s[mid]) / 2.0
