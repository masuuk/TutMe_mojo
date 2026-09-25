struct Ride:
    var distance: Float64
    var rate_per_km: Float64

    def __init__(out self, distance: Float64, rate_per_km: Float64):
        self.distance = distance
        self.rate_per_km = rate_per_km

    def fare(self) raises -> Float64:
        if self.distance < 0.0:
            raise Error("distance cannot be negative")
        return 2.0 + self.distance * self.rate_per_km

def main():
    var ride = Ride(10.0, 0.8)
    try:
        print(ride.fare())   # 10.0
    except e:
        print(e)
