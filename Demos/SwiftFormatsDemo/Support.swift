import SwiftUI

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

extension Text {
    init <Value, Format>(value: Value, format: Format) where Format: FormatStyle, Format.FormatInput == Value, Format.FormatOutput == String {
        self.init(format.format(value))
    }
}
