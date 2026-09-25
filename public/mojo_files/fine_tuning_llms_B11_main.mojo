from std.python import Python

# same run driven from Mojo: compiled orchestration, HF through the
# bridge, then the adapter merges natively (Section 4's merge_lora).
def main() raises:
    var tf  = Python.import_module("transformers")
    var bnb = tf.BitsAndBytesConfig(
        load_in_4bit=True,
        bnb_4bit_quant_type="nf4",
        bnb_4bit_use_double_quant=True)
    var model = tf.AutoModelForCausalLM.from_pretrained(
        "microsoft/Phi-3-mini-4k-instruct",
        device_map="auto", quantization_config=bnb)
    print("footprint GB:",
          model.get_memory_footprint() / 1e9)
