# ============================================================================
#  Mojo 1.x program extracted from the TutMe🔥 tutorial site.
#
#  Source:  public/data_science/time_series_analytics.html
#  File:    time_series_analytics_mojo.mojo
#
#  Extracted verbatim from the page code block (see the tutorial for prose
#  that explains each part). Run with:   mojo time_series_analytics_mojo.mojo
# ============================================================================
# Mojo 1.x: every function starts with `def` (the old `fn` keyword is gone),
# and `List` comes from the prelude so no import is needed.
def load_sales_data() -> List[Float64]:
    # build the sample series as a typed Mojo List (list display syntax)
    var data: List[Float64] = [
        120.0, 132.0, 145.0, 138.0, 150.0, 165.0, 170.0,
        158.0, 175.0, 190.0, 185.0, 200.0, 210.0, 205.0,
        220.0, 215.0, 230.0, 240.0, 235.0, 250.0, 260.0,
        255.0, 270.0, 280.0,
    ]
    return data

# Forward-fill a missing value: same idea as pandas .ffill()
def handle_missing(data: List[Float64], missing_idx: Int) -> List[Float64]:
    var result = data                  # copy the list (value semantics)
    if missing_idx > 0:
        result[missing_idx] = data[missing_idx - 1]   # reuse previous month
    return result

def main():
    var sales = load_sales_data()
    var cleaned = handle_missing(sales, 5)   # fill month 6 (index 5)
    print("Length:", len(cleaned))
    print("First 6 values:", cleaned[0], cleaned[1], cleaned[2],
          cleaned[3], cleaned[4], cleaned[5])
