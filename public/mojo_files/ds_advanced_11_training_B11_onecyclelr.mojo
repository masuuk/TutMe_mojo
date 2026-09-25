struct OneCycleLR:
    var max_lr: Float32
    var total_steps: Int
    var pct_warmup: Float32

    def lr_at(self, step: Int) -> Float32:
        var pct = Float32(step) / Float32(self.total_steps)
        if pct < self.pct_warmup:
            return self.max_lr * (pct / self.pct_warmup)
        else:
            var decay_pct = (pct - self.pct_warmup) / (1.0 - self.pct_warmup)
            return self.max_lr * (0.5 * (1.0 + cos(pi * decay_pct)))
