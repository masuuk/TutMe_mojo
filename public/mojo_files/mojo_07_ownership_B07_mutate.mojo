def mutate(mut l: List[Int]):
    l.append(5)   # no copy made

def main():
    var values = [1, 2, 3, 4]
    mutate(values)
    print(values.__str__())   # [1, 2, 3, 4, 5]
