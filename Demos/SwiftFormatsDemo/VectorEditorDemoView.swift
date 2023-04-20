import SwiftUI
import SwiftFormats
import simd

struct VectorEditorDemoView: View {

    @State
    var value: SIMD3<Float> = [0, 0, 0]

    var body: some View {
        Form {
            Section("Value") {
                Text("\(value, format: .vector())")
            }
            Section("Mapping Style") {
                TextField("Vector", value: $value, format: .vector())
            }
            Section("List Style") {
                TextField("Vector", value: $value, format: .vector(mappingStyle: false))
            }
        }
        .frame(maxWidth: 200)
    }
}
