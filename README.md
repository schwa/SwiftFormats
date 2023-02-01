# SwiftFormats

More `FormatStyle` implementation for more types.

## Description

This package provides more `FormatStyle` implementations for various types. Many types also provide `parserStrategy` implementations for parsing strings into the type where appropriate.

It also provides extensions for String and string interpolation to make it easier to format values.

## Examples

### String interpolation

```swift
let number = 123.456
let formatted = "The number is \(number, .number)"
// formatted == "The number is 123.456"
```

### CoreGraphics

```swift
let point = CGPoint(x: 1.234, y: 5.678)
let formatted = point.formatted(.decimal(places: 2))
// formatted == "(1.23, 5.68)"
```

## TODO

- [ ] Find and handle all the TODOs
- [ ] Add more `.formatted()` and `.formatted(_ style:)` functions where appropriate
- [ ] Add sugar for parsing (does a standard library equivalent to `.formatted()` exist?)
- [ ] Investigate attribute strings and other non-string `FormatOutput` types

## Resources

### Apple

- <https://developer.apple.com/documentation/foundation/formatstyle>
- <https://developer.apple.com/documentation/foundation/parseableformatstyle>
- <https://developer.apple.com/documentation/foundation/floatingpointformatstyle>

### Other

- <https://fuckingformatstyle.com>
