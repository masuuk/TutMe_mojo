var age = 25
var has_ticket = True

if age >= 18 and has_ticket:
    print("Enjoy the show")

if age < 12 or age >= 65:
    print("Discount applies")

if not has_ticket:
    print("Please buy a ticket")
