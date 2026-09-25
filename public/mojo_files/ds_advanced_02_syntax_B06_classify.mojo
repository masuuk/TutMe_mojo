# Pattern matching with match
def classify(x: Int) -> String:
    match x:
        case 0:
            return "zero"
        case 1 | 2 | 3:
            return "small"
        case _ if x > 0:
            return "positive"
        case _:
            return "negative"

# for loop with range
for i in range(5):
    print(i)

# while loop
var n = 10
while n > 0:
    n -= 1
