struct Logger:
    def __init__(out self):
        pass

    @staticmethod
    def log_info(message: String):
        print("Info:", message)

Logger.log_info("Called on type")
var l = Logger()
l.log_info("Called on instance")
