import SwiftUI
import SwiftFormats
import simd

struct VectorEditorDemoView: View {

    @State
    var value: SIMD3<Float> = [0, 0, 0]

    var body: some View {
        Form {
            Section("Value") {
                Text("\(value, format: .simd())")
            }
            Section("Mapping Style") {
                TextField("Vector", value: $value, format: .simd())
            }
            Section("List Style") {
                TextField("Vector", value: $value, format: .simd(mappingStyle: false))
            }
        }
        .frame(maxWidth: 200)
    }
}
