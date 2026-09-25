def add_to_list(var name: String, mut list: List[String]):
    list.append(name^)
    # name moved into the list → nothing to destroy here

def consume_string(var s: String):
    print(s)
    # s destroyed here
