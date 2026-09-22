# ============================================================================
#  Mojo 1.x program extracted from the TutMe🔥 tutorial site.
#
#  Source:  public/mojo_v1/advisory.html
#  File:    advisory_rows_independent.mojo
#
#  Extracted verbatim from the page code block (see the tutorial for prose
#  that explains each part). Run with:   mojo advisory_rows_independent.mojo
# ============================================================================
def convolve(img: List[List[Float64]],
             w: List[List[Float64]])  # K×K, K odd
             -> List[List[Float64]]:
    var H = len(img); var W = len(img[0])
    var K = len(w); var r = K // 2
    var out = List[List[Float64]]()
    # rows are independent — parallelize across y on a GPU
    # (max.gpu) or with multiple threads
    for y in range(H):
        var row = List[Float64]()
        for x in range(W):
            var acc = 0.0
            for i in range(K):
                for j in range(K):
                    var yy = min(max(y+i-r, 0), H-1)
                    var xx = min(max(x+j-r, 0), W-1)
                    acc += w[i][j] * img[yy][xx]
            row.append(acc)
        out.append(row^)
    return out^

def main():
    var img: List[List[Float64]] = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]]
    var w: List[List[Float64]] = [[1.0, 0.0, -1.0], [1.0, 0.0, -1.0], [1.0, 0.0, -1.0]]
    print(convolve(img, w)[0][0])
