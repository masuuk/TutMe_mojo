# Extracted from tutorials on this site (source: praxis/drill_11.html)
# https://github.com/masuuk/TutMe/blob/main/tui/public/praxis/drill_11.html

def quad(a: Float64, b: Float64, c: Float64) raises -> (Float64, Float64):
    var disc = b * b - 4.0 * a * c
    if disc < 0:
        raise Error("negative discriminant")
    var r = disc ** 0.5
    return (-b + r) / (2.0 * a), (-b - r) / (2.0 * a)

@fieldwise_init
struct User:
    var id: Int
    var name: String

def main():
    var x1, x2 = quad(1.0, -3.0, 2.0)     # x1==2.0, x2==1.0
    print(x1, x2)

    var u = User(7, "ada")
    print(u.id, u.name)

    var total = 0
    for i in range(1, 6):
        total = total + i * i
    print(total)                            # 55
