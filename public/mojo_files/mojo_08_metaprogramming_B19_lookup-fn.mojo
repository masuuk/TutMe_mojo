def lookup_fn(count: Int):
    comptime list_of_values = [1, 3, 5, 7]
    for i in range(count):
        var lookup = list_of_values[i]
        # ERROR: cannot materialize comptime value of type 'List[Int]'
        # to runtime because it is not 'ImplicitlyCopyable'
