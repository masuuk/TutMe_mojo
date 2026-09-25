import pytest

# Simple assertion test
def test_csv_parsing():
    rows = parse_csv("name,age\nAlice,30\nBob,25")
    assert len(rows) == 2
    assert rows[0]["name"] == "Alice"
    assert rows[0]["age"] == "30"

# Test with exception expectation
def test_empty_input_raises():
    with pytest.raises(ValueError):
        parse_csv("")

# Parameterized test
@pytest.mark.parametrize("input_val,expected", [
    (0.0, 0.0), (5.0, 1.0), (-3.0, 0.0)
])
def test_normalize_values(input_val, expected):
    assert normalize(input_val) == expected
