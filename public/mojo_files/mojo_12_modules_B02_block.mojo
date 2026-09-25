# Import one member:
from mymodule import MyPair
var mine = MyPair(2, 4)

# Import the whole module:
import mymodule
var mine = mymodule.MyPair(2, 4)

# Alias the module:
import mymodule as my
var mine = my.MyPair(2, 4)
