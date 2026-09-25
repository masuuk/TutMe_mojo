struct Node:
    var value: String
    var next: Optional[Node]   # ERROR: Recursive reference
