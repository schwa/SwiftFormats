import SwiftUI
import SwiftFormats
import simd

struct ContentView: View {

    @State
    var matrix = simd_float4x4()

    var body: some View {
        VStack {
            Text(matrix, format: .matrix())
            TextField("Matrix", value: $matrix, format: .matrix())
                .lineLimit(4, reservesSpace: true)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
