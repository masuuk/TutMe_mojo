from checkpoint import CheckpointManager, CheckpointConfig
from time import now

var ckpt_cfg = CheckpointConfig(
    dir="/checkpoints/run_001",
    max_keep=3,
    format=Format.SAFETENSORS,
    async_write=True
)

var mgr = CheckpointManager(ckpt_cfg)

for epoch in range(max_epochs):
    train_epoch(model, loader, cfg)
    if epoch % 5 == 0:
        // Atomic save: metadata.json written last
        mgr.save({
            "model": model.state_dict(),
            "optimizer": optimizer.state_dict(),
            "epoch": epoch,
            "timestamp": now()
        })
