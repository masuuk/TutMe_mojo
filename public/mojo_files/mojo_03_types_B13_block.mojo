var l = List[String]()      # Empty, element type as parameter
var nums = [2, 3, 5]        # Literal infers List[Int]
var bytes: List[UInt8] = [2, 3, 5]   # Or pin the element type

nums.append(7)
nums.append(11)
print("Popping last item:", nums.pop())   # 11
for idx in range(len(nums)):
    print(nums[idx], end=", ")              # 2, 3, 5, 7,

# Comprehensions for compact conditional initialization
var squares = [i * i for i in range(5)]
