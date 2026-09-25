# Mojo — same pipeline, fewer lines
from collections import Dict

struct Record:
    var id: Int
    var value: Float64
    var category: String

def process_batch(path: String) -> List[Record]:
    var content = read_file(path)
    var data = json.loads(content)
    var results = List[Record]()
    for item in data:
        if item["value"] > 0.0:
            results.append(Record(
                id=item["id"],
                value=item["value"],
                category=item["category"]
            ))
    return results

def main():
    var batches = ["batch1.json", "batch2.json"]
    for path in batches:
        var results = process_batch(path)
        print(f"Processed {len(results)} records")
