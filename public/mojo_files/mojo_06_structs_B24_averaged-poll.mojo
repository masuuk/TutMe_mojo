def averaged_poll[
    SensorType: DeflectionSensing,
](sensor: SensorType, samples: Int) -> Float64:
    var total: Float64 = 0.0
    for _ in range(samples):
        total += sensor.fetch_reading()   # guaranteed to exist
    return total / Float64(samples)

var sensor = CapacitiveSensor()
print(averaged_poll(sensor, 10))   # SensorType inferred
