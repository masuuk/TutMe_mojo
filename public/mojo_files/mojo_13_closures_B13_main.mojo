def main():
    var config = "prod"
    var count = 0
    var label = "run-1"
    def process() {imm config, mut count, var label}:
        count += 1
        print(config, count, label)
    process()     # prod 1 run-1
    label = "run-2"
    process()     # prod 2 run-1  (label copied at declaration)
