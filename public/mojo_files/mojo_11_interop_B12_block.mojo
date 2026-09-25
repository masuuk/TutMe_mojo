import mojo.importer
from mojo_module import Person

person = Person("Sarah", 32)
print(person)                    # Person(Sarah, 32)
print(person.get_name())        # Sarah
person.set_age(33)
