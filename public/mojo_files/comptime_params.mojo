# Extracted from tutorials on this site (source: praxis/drill_10.html)
# https://github.com/masuuk/TutMe/blob/main/tui/public/praxis/drill_10.html

def multiplier[factor: Int](x: Int) -> Int where factor > 0:
    return x * factor

struct S:
    var a: Int
    var b: String

def main():
    comptime times_ten = multiplier[10]
    print(times_ten(3))            # 30

    # comptime-if picks a branch during compilation
    comptime if 4 > 2:
        print("branch A is compiled")
    else:
        print("branch B is compiled")

    # reflect: field_names() returns a tuple of names (ch08)
    comptime names = reflect[S].field_names()
    print(names[0], names[1])      # a b
