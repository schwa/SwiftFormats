# SwiftFormats

More `FormatStyle` implementation for more types.

## Description

This package provides more `FormatStyle` implementations for various types. Many types also provide `parserStrategy` implementations for parsing strings into the type where appropriate.

It also provides extensions for String and string interpolation to make it easier to format values.

## Types

| Type                     | Format                | Parsable      | Notes                                |
|--------------------------|-----------------------|---------------|--------------------------------------|
| `BinaryFloatingPoint`    | Angles                | Unimplemented | Radians, degrees, etc                |
| `BinaryFloatingPoint`    | Degree Minute Seconds | Unimplemented |                                      |
| `CGPoint`                | List                  | Yes           |                                      |
| `ClosedRange`            | `X ... Y`             | Yes           |                                      |
| `CLLocationCoordinate2D` | List                  | No            |                                      |
| `BinaryFloatingPoint`    | Latitude              | No            | Including hemisphere                 |
| `BinaryFloatingPoint`    | Longitude             | No            | Including hemisphere                 |
| `Any`                    | Description           | No            | Uses `String(describing:)`           |
| `Any`                    | Dump                  | No            | Uses `dump()`                        |
| `DataProtocol`           | Hex-dumped            | No            |                                      |
| `Codable`                | JSON                  | Yes           | Uses `JSONEncoder` and `JSONDecoder` |
| `SIMD3<Float>`           | List                  | Yes           |                                      |
| `BinaryInteger`          | Radixed format        | No            | Binary, Octal, Hex representations   |

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

## Future Plans

The initial priority is to expose formats and parsers for more SIMD/CG types. Some common helper format styles will be added (e.g. "field" parser - see TODO).

### TODOs

- [ ] Find and handle all the TODOs
- [ ] Add more `.formatted()` and `.formatted(_ style:)` functions where appropriate
- [ ] Add sugar for parsing (does a standard library equivalent to `.formatted()` exist?)
- [ ] Investigate attribute strings and other non-string `FormatOutput` types
- [ ] More CoreGraphics types
- [ ] Yet another CGColor to web colour converter
- [ ] Do all SIMD types in a sane way
- [ ] Make a "field" type generic format, e.g. represent CGPoint as `x: 1.234, y: 5.678` (use for SIMD and other CG types)
- [ ] A parser for angle would be nice but `Measurement<Angle>` has no parser we can base it off.

## Resources

### Apple

- <https://developer.apple.com/documentation/foundation/formatstyle>
- <https://developer.apple.com/documentation/foundation/parseableformatstyle>
- <https://developer.apple.com/documentation/foundation/floatingpointformatstyle>

### Other

- <https://fuckingformatstyle.com>
