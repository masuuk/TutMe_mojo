def vram_budget(params: Float64,
                    lora_frac: Float64,
                    base_bytes: Float64) -> Float64:
    # trainable params cost 12 B each; frozen cost base_bytes
    var trainable = lora_frac * params
    var frozen   = (1.0 - lora_frac) * params
    return 12.0*trainable + base_bytes*frozen

def main():
    var P = 7e9
    print(vram_budget(P, 1.0,  2.0)/1e9)  # full FT:  84 GB
    print(vram_budget(P, 0.005, 2.0)/1e9)  # LoRA:  ~14.4 GB
    print(vram_budget(P, 0.005, 0.5)/1e9)  # QLoRA: ~3.9 GB
