def lookup_fn(count: Int):
    comptime list_of_values = [1, 3, 5, 7]
    var list = materialize[list_of_values]()   # allocate once, outside the loop
    for i in range(count):
        var lookup = list[i]
        process(lookup)
