var cfg = DistConfig(
    world_size=8,
    rank=0,
    backend=Backend.NCCL,
    topology=Topology.RING
)

// For multi-node: set node rank and IP
cfg.set_node(
    node_rank=0,
    node_count=2,
    master_addr="10.0.0.1",
    master_port=29500
)
