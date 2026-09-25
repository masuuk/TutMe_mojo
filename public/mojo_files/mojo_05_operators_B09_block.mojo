print(12 & 10)    # 8   (1100 & 1010 = 1000)
print(12 | 10)    # 14  (1100 | 1010 = 1110)
print(12 ^ 10)    # 6   (1100 ^ 1010 = 0110)
print(1 << 4)     # 16  shift left
print(64 >> 3)    # 8   shift right

# Building a flag register
var perms: UInt8 = 0b0000
perms |= 0b0100    # set READ bit   → 0b0100
perms |= 0b0001    # set EXEC bit   → 0b0101
perms &= 0b0111    # keep low bits  → still 0b0101
print(perms)       # 5
