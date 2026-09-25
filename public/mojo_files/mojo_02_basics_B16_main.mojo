comptime LIMIT = 5

def main():
    var scores: List[Float64] = [91.5, 84.0, 77.25, 98.5]

    # Reference binding: mutate the top score in place
    ref best = scores[3]
    best += 0.5

    # Copy: work on an independent snapshot
    var snapshot = scores.copy()
    snapshot[0] = 0.0

    # Shadowing inside the loop body block
    for i in range(len(scores)):
        var position = i + 1
        print(t"{position}: {scores[i]}")
        if position == LIMIT:
            print("Limit reached")

    print(t"original top score: {scores[3]}, snapshot first: {snapshot[0]}")
