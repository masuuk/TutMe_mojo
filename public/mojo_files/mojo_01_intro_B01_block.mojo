# Install uv if you don't have it
curl -LsSf https://astral.sh/uv/install.sh | sh

# Option A: install into your environment
uv pip install mojo

# Option B: create a dedicated project
uv init temperature-analyzer
cd temperature-analyzer
uv add mojo
