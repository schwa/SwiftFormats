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
