# Anonymous: don't need to name the type
def averaged_poll_2(sensor: Some[DeflectionSensing],
                   samples: Int) -> Float64: ...

# Named: needed when referring twice — e.g. two args of the same type
def compare_readings[SensorType: DeflectionSensing](
    a: SensorType, b: SensorType,
) -> Float64:
    return a.fetch_reading() - b.fetch_reading()
