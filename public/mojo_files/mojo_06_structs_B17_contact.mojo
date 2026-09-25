@fieldwise_init
struct Contact:
    var name: String
    var email: String

    def __deinit__(deinit self):
        # `self` still fully initialized here
        print("destroying contact")
