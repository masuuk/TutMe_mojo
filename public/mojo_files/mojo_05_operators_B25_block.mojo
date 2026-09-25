var values = [1, 2, 3]
for ref v in values:
    v += 10                   # writes through the reference
print(values[0])             # 11
