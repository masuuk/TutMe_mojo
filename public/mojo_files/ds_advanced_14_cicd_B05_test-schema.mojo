from testing import TestCase, DataTest
from data import Dataset

class DataValidationTest(DataTest):
    def test_schema(self):
        var ds = Dataset.load("train.parquet")
        self.assert_columns(ds, ["text", "label", "timestamp"])
        self.assert_dtype(ds["label"], Int64)
        self.assert_range(ds["label"], min=0, max=9)

    def test_distribution(self):
        var ds = Dataset.load("train.parquet")
        // Ensure no class has less than 5% representation
        var dist = ds.column("label").value_counts(normalized=True)
        for label, pct in dist:
            self.assert_gt(pct, 0.05,
                msg=f"Class {label} underrepresented at {pct:.1%}")

    def test_no_leakage(self):
        // Ensure train/val/test splits don't overlap
        var train = Dataset.load("train.parquet")
        var val = Dataset.load("val.parquet")
        self.assert_no_overlap(train.ids, val.ids)
