# ============================================================================
#  Mojo 1.x program extracted from the TutMe🔥 tutorial site.
#
#  Source:  public/mojo_v1/advisory.html
#  File:    advisory_layout.mojo
#
#  Extracted verbatim from the page code block (see the tutorial for prose
#  that explains each part). Run with:   mojo advisory_layout.mojo
# ============================================================================
# CSR layout: edges sorted by source —
# sequential memory, no pointer chasing
#   offsets[v]   .. offsets[v+1]  = v's edges
#   edge_dst[e], edge_w[e]

from std.math import inf

# O(V²) Dijkstra — keeps the card self-contained
# (a binary heap gives O(E log V) with the same CSR layout)
def dijkstra(off: List[Int], dst: List[Int],
             w: List[Float64], s: Int)
             -> List[Float64]:
    var n = len(off) - 1
    var d = List[Float64]()
    for _ in range(n):
        d.append(inf[DType.float64]())  # best distance so far
    var done = List[Bool]()
    for _ in range(n):
        done.append(False)
    d[s] = 0.0
    for _ in range(n):
        # pick the unvisited node with the smallest d
        var u = -1
        for v in range(n):
            if (not done[v]) and (u == -1 or d[v] < d[u]):
                u = v
        if u == -1:
            break                     # remaining nodes unreachable
        done[u] = True
        # relax every edge leaving u
        for e in range(off[u], off[u + 1]):
            var nd = d[u] + w[e]
            if nd < d[dst[e]]:
                d[dst[e]] = nd
    return d^

def main():
    # 4 nodes: 0->1 (1), 0->2 (4), 1->2 (2), 1->3 (6), 2->3 (1)
    var off: List[Int] = [0, 2, 4, 5, 5]
    var dst: List[Int] = [1, 2, 2, 3, 3]
    var wgt: List[Float64] = [1.0, 4.0, 2.0, 6.0, 1.0]
    print(dijkstra(off, dst, wgt, 0))
