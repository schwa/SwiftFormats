import SwiftUI
import SwiftFormats
import simd

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Matrix Editor") {
                    MatrixEditorDemoView()
                }
                NavigationLink("Vector Editor") {
                    VectorEditorDemoView()
                }
            }
        }
    }
}

// MARK: -

struct MatrixEditorDemoView: View {

    @State
    var matrix = simd_float4x4()

    var body: some View {
        VStack {
            Text(matrix, format: .matrix)
            TextEditor(value: $matrix, format: .matrix)
                .lineLimit(4, reservesSpace: true)
        }
        .padding()
    }
}

// MARK: -

struct VectorEditorDemoView: View {

    @State
    var value: SIMD3<Float> = [0, 0, 0]

    var body: some View {
        TextField("Vector", value: $value, format: .vector.compositeStyle(.list))
//        Form {
//            Section("Value") {
//                Text("\(value, format: .vector)")
//            }
//            Section("Mapping Style") {
//                TextField("Vector", value: $value, format: .vector)
//            }
////            Section("List Style") {
////                TextField("Vector", value: $value, format: .vector.compositeStyle(.list))
////            }
//        }
//        .frame(maxWidth: 200)
    }
}

