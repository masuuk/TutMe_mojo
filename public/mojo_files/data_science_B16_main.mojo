def main():
    var rows: String = "Ana,math,92,yes\nBo,math,74,yes\nCam,math,58,no\nAna,physics,81,yes\nBo,physics,88,yes\nCam,physics,65,no"
    var passed: Int = 0                     # boolean mask on rows (score ≥ 60)
    var top: Int = -1
    var top_student: String = ""
    for line in rows.split("\n"):
        var cols = line.split(",")
        var score = atol(cols[2])
        if score >= 60:
            passed += 1
        if score > top:                # argmax via scan
            top = score
            top_student = cols[0]
    print("passed =", passed)          # → 5   (only Cam fails)
    print(top_student, top)                # Ana 92
