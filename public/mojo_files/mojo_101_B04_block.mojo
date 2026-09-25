var data: List[Float64] = [1.0, 2.5, 0.0, 9.0, 4.0]

# 1) keep only positive values
var clean: List[Float64] = []
for x in data:
    if x > 0.0:
        clean.append(x)

# 2) lowest and highest in one pass
var lo = clean[0]
var hi = clean[0]
for x in clean:
    if x < lo:
        lo = x
    if x > hi:
        hi = x

# 3) rescale to 0..1
var scaled: List[Float64] = []
for x in clean:
    scaled.append((x - lo) / (hi - lo))
print(scaled)   # [0.0, 0.2777, 1.0, 0.4444]
