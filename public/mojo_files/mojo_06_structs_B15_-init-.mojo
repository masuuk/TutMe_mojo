def __init__(out self, name: String, age: Int):
    self.name = name
    # ERROR if we stop here: field 'age' not initialized
    self.age = age

# Field sources can be anything: parameters, constants,
# or external values:
from std.math import pi
var default_angle = pi / 2.0
