import Foundation
import SwiftFormats
import simd

//let measurements: [Measurement] = [
//    Measurement(value: 45.123, unit: UnitAngle.degrees),
//    Measurement(value: 45.123, unit: UnitAngle.arcMinutes),
//    Measurement(value: 45.123, unit: UnitAngle.arcSeconds),
//    Measurement(value: 45.123, unit: UnitAngle.radians),
//    Measurement(value: 45.123, unit: UnitAngle.gradians),
//    Measurement(value: 45.123, unit: UnitAngle.revolutions),
//]
//
//for measurement in measurements {
//    print(measurement.formatted(.measurement(width: .abbreviated)))
//    print(measurement.formatted(.measurement(width: .narrow)))
//    print(measurement.formatted(.measurement(width: .wide)))
//}


let s = SimpleListFormatStyle(substyle: FloatingPointFormatStyle<Float>.number)

let vector:SIMD3<Float> = [1,2,3]

let a = "\(vector, format: .simd())"
try SIMDFormatStyle().parseStrategy.parse(a)
