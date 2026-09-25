from python import Python

def main() raises:
    var torch = Python.import_module("torch")
    var nn = Python.import_module("torch.nn")
    var optim = Python.import_module("torch.optim")

    var net = nn.Sequential(
        nn.Linear(4, 8), nn.ReLU(),
        nn.Linear(8, 1))
    var opt = optim.Adam(net.parameters(), lr=1e-3)
    var loss_fn = nn.MSELoss()

    var X = torch.randn(64, 4)
    var y = (X[Python.slice(), 0] * 2
            + X[Python.slice(), 1] - 1).unsqueeze(1)

    for step in range(300):
        opt.zero_grad()
        var loss = loss_fn(net(X), y)
        loss.backward()           # autograd — still Python
        opt.step()
    print(loss.item().__round__(5))
