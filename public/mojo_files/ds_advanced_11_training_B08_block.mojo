var mgr = CheckpointManager(ckpt_cfg)

// First save: full checkpoint
mgr.save(model.state_dict(), full=True)

// Subsequent saves: only diff from previous
for step in range(1000):
    train_step(model, batch)
    if step % 100 == 0:
        mgr.save(model.state_dict(), full=False)
        // Only ~2-5% of tensors typically change per step
