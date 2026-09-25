from collections import Dict

def main():
    var courses = ["math", "math", "math",
                    "physics", "physics", "physics"]
    var score = [92, 74, 58, 81, 88, 65]
    var sum_ = Dict[String, Int]()       # per-course total score
    var max_ = Dict[String, Int]()
    var count = Dict[String, Int]()

    for i in range(courses.size):     # split-apply-combine, one pass
        var c = courses[i]
        sum_[c] = sum_.get(c, 0) + score[i]
        max_[c] = max(max_.get(c, 0), score[i])
        count[c] = count.get(c, 0) + 1

    for c in count.keys():
        print(c, "mean", float64(sum_[c]) / float64(count[c]),
              "max", max_[c], "count", count[c])
    # math: 74.7 / 92 / 3 · physics: 78 / 88 / 3
