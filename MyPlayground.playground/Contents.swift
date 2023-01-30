import Foundation

let measurements: [Measurement] = [
    Measurement(value: 45.123, unit: UnitAngle.degrees),
    Measurement(value: 45.123, unit: UnitAngle.arcMinutes),
    Measurement(value: 45.123, unit: UnitAngle.arcSeconds),
    Measurement(value: 45.123, unit: UnitAngle.radians),
    Measurement(value: 45.123, unit: UnitAngle.gradians),
    Measurement(value: 45.123, unit: UnitAngle.revolutions),
]

for measurement in measurements {
    print(measurement.formatted(.measurement(width: .abbreviated)))
    print(measurement.formatted(.measurement(width: .narrow)))
    print(measurement.formatted(.measurement(width: .wide)))
}


