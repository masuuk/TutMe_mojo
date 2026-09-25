from math import sin, cos, sinh, cosh

struct Alpha:
    var a1: Float64; var a2: Float64; var a3: Float64
    var a4: Float64; var a5: Float64; var a6: Float64

def krueger_alpha(n: Float64) -> Alpha:
    var n2 = n * n
    var n3 = n2 * n
    var n4 = n3 * n
    var n5 = n4 * n
    var n6 = n5 * n
    return Alpha(
        n/2 - 2*n2/3 + 5*n3/16 + 41*n4/180 - 127*n5/288 + 7891*n6/37800,
        13*n2/48 - 3*n3/5 + 557*n4/1440 + 281*n5/630 - 1983433*n6/1935360,
        61*n3/240 - 103*n4/140 + 15061*n5/26880 + 167603*n6/181440,
        49561*n4/161280 - 179*n5/168 + 6601661*n6/7257600,
        34729*n5/80640 - 3418889*n6/1995840,
        212378941*n6/319334400,
    )

def main():
    var n = (1.0 / 298.257223563) / (2.0 - 1.0 / 298.257223563)
    var al = krueger_alpha(n)
    print("alpha1 =", al.a1)      # 0.0008377318206233399
    print("alpha2 =", al.a2)      # 7.608527773574e-07
