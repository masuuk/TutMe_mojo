var source = String("Hello")
var copied = source   # A copy — both names stay valid
var moved = source^   # A transfer — source is now uninitialized!
