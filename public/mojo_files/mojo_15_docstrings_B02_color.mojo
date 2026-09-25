struct Color:
    """Represents an RGB color."""          # Struct docstring

    var r: UInt8
    """The red channel, in [0, 255]."""      # Field docstring

    comptime MAX: UInt8 = 255
    """The maximum value for any channel."""  # comptime docstring

    def to_hex(self) -> String:
        """Converts the color to a hex string.""" # Method docstring
        ...
