import SwiftUI
import SwiftFormats
import simd
import CoreLocation

protocol DefaultInitialisable {
    init()
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                demo(of: AngleEditorDemoView.self)
                demo(of: ClosedRangeEditorDemoView.self)
                demo(of: CoordinatesEditorDemoView.self)
                demo(of: HexDumpFormatDemoView.self)
                demo(of: JSONFormatDemoView.self)
                demo(of: MatrixEditorDemoView.self)
                demo(of: PointEditorDemoView.self)
                demo(of: QuaternionDemoView.self)
                demo(of: VectorEditorDemoView.self)
                demo(of: AngleRangeEditorDemo.self)
            }
        }
    }

    func demo<T>(of t: T.Type) -> some View where T: View & DefaultInitialisable {
        let name = String(String(describing: type(of: t)).prefix(while: { $0 != "." }))
        return NavigationLink(name) {
            t.init()
        }
    }
}

// MARK: -

struct AngleEditorDemoView: View, DefaultInitialisable {
    @State
    var value: Double = 45

    @State
    var angleValue = Angle.degrees(45)

    var body: some View {
        Form {
            Section("String(describing:)") {
                Text(verbatim: "\(value)")
            }
            Section("Formatting TextField (degrees)") {
                TextField("Degrees", value: $value, format: .angle(inputUnit: .degrees, outputUnit: .degrees))
                    .labelsHidden()
                    .frame(maxWidth: 160)
            }
            Section("Formatting TextField (radians)") {
                TextField("Radians", value: $value, format: .angle(inputUnit: .degrees, outputUnit: .radians))
                    .labelsHidden()
                    .frame(maxWidth: 160)
            }

            Section("String(describing:)") {
                Text(verbatim: "\(angleValue)")
            }
            Section("Formatting TextField (degrees)") {
                TextField("Degrees", value: $angleValue, format: .angle.defaultInputUnit(.degrees))
                    .labelsHidden()
                    .frame(maxWidth: 160)
            }
            Section("Formatting TextField (radians)") {
                TextField("Radians", value: $angleValue, format: .angle)
                    .labelsHidden()
                    .frame(maxWidth: 160)
            }
        }
    }
}

// MARK: -

struct ClosedRangeEditorDemoView: View, DefaultInitialisable {
    @State
    var value = 1...10

    var body: some View {
        Form {
            Section("String(describing:)") {
                Text(verbatim: "\(value)")
            }
            Section("Formatting TextField") {
                TextField("Value", value: $value, format: ClosedRangeFormatStyle(substyle: .number))
                    .labelsHidden()
                    .frame(maxWidth: 160)
            }
        }
    }
}

// MARK: -

struct CoordinatesEditorDemoView: View, DefaultInitialisable {
    @State
    var value = CLLocationCoordinate2D(latitude: 45, longitude: 45)

    var body: some View {
        Text("Broken!")
//        Form {
//            Section("String(describing:)") {
//                Text(verbatim: "\(value)")
//            }
//            Section("Formatted Text") {
//                Text("\(value, format: .coordinates)")
//            }
//        }
    }
}

struct HexDumpFormatDemoView: View, DefaultInitialisable {
    @State
    var value: Data = "Hello world".data(using: .utf8)!

    var body: some View {
        Form {
            Section("String(describing:)") {
                Text(verbatim: "\(value)")
            }
            Section("Formatted Text") {
                Text("\(value, format: .hexdump())")
                    .font(.body.monospaced())
            }
        }
    }
}

struct JSONFormatDemoView: View, DefaultInitialisable {
    @State
    var value = ["Hello": "World"]

    var body: some View {
        Form {
            Section("String(describing:)") {
                Text(verbatim: "\(value)")
            }
            Section("Formatting TextField") {
                TextField("json", value: $value, format: JSONFormatStyle())
            }
        }
    }
}

// MARK: -

struct QuaternionDemoView: View, DefaultInitialisable {
    @State
    var value = simd_quatd(real: 0, imag: [0, 0, 0])

    var body: some View {
        Form {
            Section("String(describing:)") {
                Text(verbatim: "\(value)")
            }
            Section("Formatted Text") {
                Text(value: value, format: .quaternion)
            }
            Section("Formatting TextField") {
                TextField("value", value: $value, format: .quaternion)
            }
        }
    }
}

// MARK: -

struct MatrixEditorDemoView: View, DefaultInitialisable {
    @State
    var value = simd_float4x4()

    var body: some View {
        Form {
            Section("String(describing:)") {
                Text(verbatim: "\(value)")
            }
            Section("Formatted Text") {
                Text(value, format: .matrix)
            }
            Section("Formatting TextField") {
                TextField("matrix", value: $value, format: .matrix)
                    .lineLimit(4, reservesSpace: true)
                    .labelsHidden()
                    .frame(maxWidth: 160)
            }
            Section("Formatting TextEditor") {
                TextEditor(value: $value, format: .matrix)
                    .lineLimit(4, reservesSpace: true)
                    .frame(maxHeight: 200)
            }
        }
    }
}

// MARK: -

struct PointEditorDemoView: View, DefaultInitialisable {
    @State
    var value = CGPoint.zero

    var body: some View {
        Form {
            Section("String(describing:)") {
                Text(verbatim: "\(value)")
            }
            Section("Formatting TextField") {
                TextField("Value", value: $value, format: .point)
                    .labelsHidden()
                    .frame(maxWidth: 160)
            }
        }
    }
}

// MARK: -

struct VectorEditorDemoView: View, DefaultInitialisable {

    @State
    var value: SIMD3<Float> = [0, 0, 0]

    var body: some View {
        Form {
            Text(verbatim: "\(value)")
            Section("Value") {
                Text("\(value, format: .vector)")
            }
            Section("Mapping Style") {
                TextField("Vector", value: $value, format: .vector)
            }
            Section("List Style") {
                TextField("Vector", value: $value, format: .vector.compositeStyle(.list))
            }
        }
    }
}

// MARK: -

struct AngleRangeEditorDemo: View, DefaultInitialisable {

    @State
    var value: ClosedRange<Angle> = .degrees(0) ... .degrees(180)

    var body: some View {
        TextField("Angles", value: $value, format: ClosedRangeFormatStyle(substyle: .angle))
    }


}
