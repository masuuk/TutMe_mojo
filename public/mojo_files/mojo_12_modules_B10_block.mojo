# Compile the package to a .mojoc file:
$ mojo precompile mypackage -o mypack.mojoc

# Project can now ship source elsewhere; layout becomes:
project
├── main.mojo
└── mypack.mojoc

# The .mojoc filename becomes the package name, so:
from mypack.mymodule import MyPair
