# If f.read() raises, close() never runs:
# buffered writes are lost, handles leak.
var f = open(input_file, "r")
var content = f.read()
f.close()

# try/finally fixes it, verbosely:
var g = open(input_file, "r")
try:
    var content = g.read()
finally:
    g.close()
