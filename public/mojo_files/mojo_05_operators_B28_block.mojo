var haystack = [4, 8, 15]

for target in [8, 16]:
    if target in haystack:
        print(target, "found")
        break
else:
    print("no match found")   # runs — 16 never matched
