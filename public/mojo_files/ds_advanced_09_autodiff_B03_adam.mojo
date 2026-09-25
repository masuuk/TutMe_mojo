struct Adam:
    var lr: Float64
    var beta1: Float64
    var beta2: Float64
    var eps: Float64
    var t: Int
    var m: Dict[String, Float64]
    var v: Dict[String, Float64]

    def __init__(
        mut self,
        lr: Float64 = 0.001,
        beta1: Float64 = 0.9,
        beta2: Float64 = 0.999,
        eps: Float64 = 1e-8
    ):
        self.lr = lr
        self.beta1 = beta1
        self.beta2 = beta2
        self.eps = eps
        self.t = 0
        self.m = Dict[String, Float64]()
        self.v = Dict[String, Float64]()

    def step(mut self, params: Dict[String, Float64], grads: Dict[String, Float64]):
        self.t += 1
        for key in grads:
            var g = grads[key]

            // Update biased moments
            self.m[key] = self.beta1 * self.m.get(key, 0.0) + (1.0 - self.beta1) * g
            self.v[key] = self.beta2 * self.v.get(key, 0.0) + (1.0 - self.beta2) * g * g

            // Bias correction
            var m_hat = self.m[key] / (1.0 - self.beta1 ** Float64(self.t))
            var v_hat = self.v[key] / (1.0 - self.beta2 ** Float64(self.t))

            // Update parameters
            params[key] -= self.lr * m_hat / (sqrt(v_hat) + self.eps)


def sgd_step(
    mut params: List[Float64],
    grads: List[Float64],
    lr: Float64
):
    for i in range(len(params)):
        params[i] -= lr * grads[i]
