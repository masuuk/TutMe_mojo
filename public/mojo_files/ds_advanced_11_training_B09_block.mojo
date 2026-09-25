from optim.lr_scheduler import (
    CosineAnnealingLR, WarmupLinear, SequentialScheduler
)

// Build a warmup + cosine decay schedule
var schedule = SequentialScheduler([
    WarmupLinear(
        warmup_steps=1000,
        start_lr=1e-6,
        peak_lr=3e-4
    ),
    CosineAnnealingLR(
        total_steps=50000,
        min_lr=1e-6
    )
])

// Composable: combine with gradient accumulation
var effective_lr = schedule.lr_at(step) * cfg.grad_accum_steps

// Stateful: save/restore with checkpoint
mgr.save({
    "model": model.state_dict(),
    "scheduler": schedule.state_dict()
})
