if x > 0:
    print("positive")
elif x < 0:
    print("negative")
else:
    print("zero")

# These Python idioms do NOT work:
# x > 0 and print("positive")   # Error: 'None' isn't truthy
# print("positive") if x > 0 else pass  # Error: 'pass' isn't an expression
