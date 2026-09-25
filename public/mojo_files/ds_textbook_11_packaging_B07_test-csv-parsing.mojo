from testing import test, assert_equal, assert_true

# Simple assertion test
@test
def test_csv_parsing():
    var rows = parse_csv("name,age\nAlice,30\nBob,25")
    assert_equal(rows.num_rows(), 2)
    assert_equal(rows[0]["name"], "Alice")
    assert_equal(rows[0]["age"], "30")

# Test with exception expectation
@test
def test_empty_input_raises():
    try:
        parse_csv("")
        assert_true(False, "Should have raised ValueError")
    except Error:
        pass  # expected

# Parameterized test
@test
def test_normalize_values():
    var cases = [(0.0, 0.0), (5.0, 1.0), (-3.0, 0.0)]
    for input_val, expected in cases:
        assert_equal(normalize(input_val), expected)
