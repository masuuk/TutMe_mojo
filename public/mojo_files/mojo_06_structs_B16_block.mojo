var me = Person("Connor", 25)
var name_owner = me.name^   # moves name out of me.name

print(me)          # ERROR: use of uninitialized value 'me'
me.name = "John"   # reinitialize the moved-from field...
print(me)          # ...and the instance is usable again
