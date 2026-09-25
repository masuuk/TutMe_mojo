struct MyStruct:
    var foo: Int

    def use_argument(self, foo: Int):   # argument shadows field
        print(foo)                     # prints argument value

    def use_local(self, value: Int):
        var foo = value                # local shadows field
        print(foo, self.foo)           # local first, then field
