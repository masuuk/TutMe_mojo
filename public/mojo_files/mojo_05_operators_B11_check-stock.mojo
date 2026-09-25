def check_stock() -> Bool:
    print("checking stock...")
    return True

var ok = False and check_stock()   # no output — RHS skipped
ok = True or check_stock()         # no output — RHS skipped
