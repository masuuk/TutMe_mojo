var data = [1, 2, 3]

# Both of these are equivalent:
process(data^)  # explicit transfer
process(data)   # implicit — compiler sees data isn't used after

# But this would NOT auto-transfer:
process(data)
print(data)      # data is used again — no auto-transfer
