def main():
    var data: List[Int] = [1, 2, 3]
    def take_data() {var data^}:
        print(data)
    take_data()      # [1, 2, 3]
    # print(data)    # error: 'data' is uninitialized after move
