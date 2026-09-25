# CSR layout: edges sorted by source —
# sequential memory, no pointer chasing
#   offsets[v]   .. offsets[v+1]  = v's edges
#   edge_dst[e], edge_w[e]

def dijkstra(off: List[Int], dst: List[Int],
             w: List[Float64], s: Int)
             -> List[Float64]:
    var n = len(off) - 1
    var d = List[Float64](n, inf)  # best distance so far
    var pq = Heap[Float64, Int]()
    d[s] = 0.0
    pq.push(0.0, s)
    while pq.size() > 0:
        var (du, u) = pq.pop()      # smallest d(u) first
        if du > d[u]:
            continue                # stale entry, skip
        # relax every edge leaving u
        for e in range(off[u], off[u + 1]):
            var nd = du + w[e]
            if nd < d[dst[e]]:
                d[dst[e]] = nd
                pq.push(nd, dst[e])
    return d
