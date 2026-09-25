var questions: List[String] = [
    "2 + 2 = ?", "4 * 3 = ?",
]
var answers: List[Int] = [4, 12]
var guesses: List[Int] = [4, 10]

var score = 0
for i in range(len(questions)):
    if guesses[i] == answers[i]:
        score += 1
        print(questions[i], "-> correct")
    else:
        print(questions[i], "-> missed")
print("score:", score, "of", len(questions))   # 1 of 2
