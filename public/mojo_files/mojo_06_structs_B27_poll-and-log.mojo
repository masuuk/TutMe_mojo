def poll_and_log[T: DeflectionSensing & Loggable](sensor: T):
    print(sensor.fetch_reading())
    sensor.log("Polling sensor")

# Reuse a combination via an alias:
comptime SensorLike = DeflectionSensing & Loggable
