@fieldwise_init
struct CapacitiveSensor(Copyable, DeflectionSensing):
    def fetch_reading(self) -> Float64:
        return 21.5

# Refinement: inherits every requirement, adds new ones
trait CalibratableSensing(DeflectionSensing):
    def calibrate(mut self):
        ...
