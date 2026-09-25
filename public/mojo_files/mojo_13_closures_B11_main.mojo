def main():
    var label = "sensor-1"
    def tag() {var^} -> String:
        return label
    var clone = tag     # closure value copied
    print(tag())     # sensor-1
    print(clone())    # sensor-1
