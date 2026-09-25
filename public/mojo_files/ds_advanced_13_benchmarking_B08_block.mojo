from async import Pipeline, Stage

// Pipeline: prefetch → preprocess → compute
var pipeline = Pipeline([
    Stage("load", def(): loader.next_batch(), buffer=4),
    Stage("preprocess", def(b): augment(b), buffer=2),
    Stage("compute", def(b): model.forward(b), buffer=1),
])

// All 3 stages run concurrently on different data
for batch in pipeline:
    loss = loss_fn(batch, targets)
    loss.backward()
