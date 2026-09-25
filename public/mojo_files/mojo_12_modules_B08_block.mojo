# Before: full dotted path required
from mypackage.mymodule import MyPair

# After: the package re-exports it
from mypackage import MyPair
