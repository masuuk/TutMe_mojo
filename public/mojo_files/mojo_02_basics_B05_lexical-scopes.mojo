def lexical_scopes():
    var num = 1
    var dig = 1
    if num == 1:
        print("num:", num)   # Reads the outer-scope "num"
        var num = 2          # Creates a NEW inner-scope "num"
        print("num:", num)   # Reads the inner-scope "num"
        dig = 2              # Updates the outer-scope "dig"
    print("num:", num)       # Reads the outer-scope "num"
    print("dig:", dig)       # Reads the outer-scope "dig"

def main():
    lexical_scopes()
