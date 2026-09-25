from std.python import Python

def batch_transform_csv(input_csv: String, output_csv: String) raises:
    var pd = Python.import_module("pandas")
    var tm_mod = Python.import_module("geographiclib.transverse_mercator")
    var tm = tm_mod.TransverseMercator(6378137, 1 / 298.257223563, k0=0.9996)

    var df = pd.read_csv(input_csv)
    var n = len(df)
    for i in range(n):                     # Mojo owns the loop — compiled, parallelize-ready
        var row = df.iloc[i]
        var res = tm.Forward(0, row["lat"], row["lon"])
        df.at[i, "easting"] = res[0]
        df.at[i, "northing"] = res[1]
    df.to_csv(output_csv, index=False)
    print("Transformed", n, "points.")
