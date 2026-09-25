# Install pixi if you don't have it
curl -fsSL https://pixi.sh/install.sh | sh

# Create a project and install Mojo
pixi init temperature-analyzer \
    -c https://conda.modular.com/max/ \
    -c conda-forge
cd temperature-analyzer
pixi add mojo
pixi shell
