from ci import Pipeline, Stage, Gate, Trigger

var pipeline = Pipeline(
    name="llm-training",
    trigger=Trigger.push(branch="main"),

    stages=[
        Stage("validate_data",
            command="mojo test tests/data/",
            cache=CacheKey.from_files(["data/**"])
        ),
        Stage("train",
            command="mojo train.py --config config/prod.yaml",
            gpu=8,
            timeout="4h",
            depends_on=["validate_data"]
        ),
        Stage("evaluate",
            command="mojo eval.py --model artifacts/model.mojomodel",
            gates=[
                Gate.min_accuracy(0.92),
                Gate.max_latency_ms(50),
                Gate.max_memory_gb(4.0),
            ]
        ),
        Stage("deploy_canary",
            command="mojo-serve deploy --traffic 5%",
            auto_rollback=True,
            monitor_minutes=30
        ),
        Stage("deploy_full",
            command="mojo-serve deploy --traffic 100%",
            requires_approval=True
        ),
    ]
)
