def process_record(id: Int) raises -> String:
    if id > 999:
        raise Error("record not found")
    return String("record_", id)

def main() raises:
    try:
        var result = process_record(1001)
    except e:
        print("handled:", e)
    else:
        print("success:", result)
    finally:
        print("cleanup always runs")
