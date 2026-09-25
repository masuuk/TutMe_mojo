from distributed import DistConfig, all_reduce
from tensor import Tensor, Float32

def train_epoch(model: Model, loader: DataLoader, cfg: DistConfig):
    for batch in loader.shard(cfg.rank, cfg.world_size):
        var loss = model.forward(batch.data, batch.labels)
        loss.backward()
        // Synchronize gradients across all ranks
        for param in model.parameters():
            all_reduce(param.grad, op=ReduceOp.AVG, group=cfg.group)
        model.optimizer.step()
        model.zero_grad()
