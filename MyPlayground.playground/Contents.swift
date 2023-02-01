import Foundation
import SwiftFormats
import simd
import PlaygroundSupport
import SwiftUI


//Locale.availableIdentifiers.map { Locale(identifier: $0) }.forEach { locale in
//
//    print(locale, terminator: "\t")
//
//    let measurements: [Measurement] = [
//        Measurement(value: 45.123, unit: UnitAngle.degrees),
//        Measurement(value: 45.123, unit: UnitAngle.arcMinutes),
//        Measurement(value: 45.123, unit: UnitAngle.arcSeconds),
//        Measurement(value: 45.123, unit: UnitAngle.radians),
//        Measurement(value: 45.123, unit: UnitAngle.gradians),
//        Measurement(value: 45.123, unit: UnitAngle.revolutions),
//    ]
//
//    for measurement in measurements {
//        print(measurement.formatted(.measurement(width: .abbreviated).locale(locale)), terminator: "\t")
//        print(measurement.formatted(.measurement(width: .narrow).locale(locale)), terminator: "\t")
//        print(measurement.formatted(.measurement(width: .wide).locale(locale)), terminator: "\t")
//    }
//    print("")
//}

//let f = MeasurementFormatter()
//f.unitStyle = .long
//f.unitOptions = .providedUnit
//f
//f.getObjectValue(nil, for: "45°", errorDescription: nil)
////struct ContentView: View {
////
////    @State
////    var value = 1.0 ... 2.0
////
////    var body: some View {
////        VStack {
////            TextField("Value", value: $value, format: ClosedRangeFormatStyle(substyle: .number))
////            Text(verbatim: "\(value)")
////        }
////        .frame(width: 320, height: 240)
////        .border(Color.red)
////    }
////}
////
////
////PlaygroundPage.current.setLiveView(ContentView())

func a() {
    let angle = 0.785398 // 45°
    let q = simd_quatd(angle: angle, axis: [0, 0, 1])
    let vector = q.act([1, 0, 0])
    atan2(vector.x, vector.y)
}
a()

func b() {
    let angle = 0.785398 // 45°
    let q = simd_quatd(angle: angle, axis: [0, 1, 0])
    let vector = q.act([0, 0, 1])
    atan2(vector.x, vector.z)
}
b()

func c() {
    let angle = 0.785398 // 45°
    let q = simd_quatd(angle: angle, axis: [1, 0, 0])
    let vector = q.act([0, 1, 0])
    atan2(vector.y, vector.z)
}
c()
