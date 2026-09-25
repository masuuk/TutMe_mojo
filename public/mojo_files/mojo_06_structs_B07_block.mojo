var a = MyPair(1, 2)

var b = a      # ERROR: cannot be implicitly copied,
               # does not conform to 'ImplicitlyCopyable'

var c = a.copy()  # ERROR: same reason

var d = a^     # ERROR: cannot be copied or moved; consider
               # conforming to 'Copyable'
