var i_like = {"sushi", "ice cream", "tacos", "pho"}
var you_like = {"burgers", "tacos", "salad", "ice cream"}

var we_like = i_like.intersection(you_like)
print("We both like:")
for item in we_like:
    print("-", item)
