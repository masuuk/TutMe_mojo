// Contributing to the Mojo ecosystem is easy
// Write a package, publish it, others can use it

// my_package/mojo.mod
name = "my_ml_utils"
version = "0.2.0"
dependencies = [
    "mojo-stdlib",
    "mojo-nn",
]

// Users can precompile and import it:
// mojo precompile my_ml_utils -o my_ml_utils.mojoc

// Or import directly from GitHub:
from my_ml_utils import CustomAttention
