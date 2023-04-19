import SwiftUI
import SwiftFormats
import simd

struct MatrixEditorDemoView: View {

    @State
    var matrix = simd_float4x4()

    var body: some View {
        VStack {
            Text(matrix, format: .matrix())
            TextEditor(value: $matrix, format: .matrix())
                .lineLimit(4, reservesSpace: true)
        }
        .padding()
    }
}

struct MatrixEditorDemoView_Previews: PreviewProvider {
    static var previews: some View {
        MatrixEditorDemoView()
    }
}

extension TextEditor {
    init <Value, Format>(value: Binding<Value>, format: Format) where Format: ParseableFormatStyle, Format.FormatInput == Value, Format.FormatOutput == String {
        var safe = true
        var string = format.format(value.wrappedValue)

        let binding = Binding<String> {
            if safe {
                return format.format(value.wrappedValue)
            }
            else {
                return string
            }
        } set: { newValue in
            do {
                value.wrappedValue = try format.parseStrategy.parse(newValue)
            }
            catch {
                safe = false
                string = newValue
            }
        }
        self.init(text: binding)
    }
}
