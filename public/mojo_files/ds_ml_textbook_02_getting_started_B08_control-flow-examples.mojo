def control_flow_examples():
    # if / elif / else
    var score = 85
    if score >= 90:
        print("Excellent")
    elif score >= 70:
        print("Good")
    else:
        print("Needs improvement")

    # for loop with range
    for i in range(5):
        print(i)

    # for loop over a list
    var fruits = ["apple", "banana", "cherry"]
    for fruit in fruits:
        print(fruit)

    # while loop
    var n = 5
    while n > 0:
        print(n)
        n -= 1
