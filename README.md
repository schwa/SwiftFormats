# SwiftFormats

More `FormatStyle` implementation for more types.

## Description

This package provides more `FormatStyle` implementations for various types. Many types also provide `parserStrategy` implementations for parsing strings into the type where appropriate.

It also provides extensions for String and string interpolation to make it easier to format values.

## Types

<!-- TODO: Big table. Break it down. -->

| Name | In (1)                   | Out (2)  | Format (3)            | Parser (4) | Accessor (5)  | Notes                                |
|------|--------------------------|----------|-----------------------|------------|---------------|--------------------------------------|
|      | `BinaryFloatingPoint`    | `String` | Angles                | No         | `angle`       | Radians, degrees, etc                |
|      | `BinaryFloatingPoint`    | `String` | Degree Minute Seconds | No         | `dmsNotation` |                                      |
|      | `CGPoint`                | `String` | List (6)              | Yes        | `point`       |                                      |
|      | `ClosedRange`            | `String` | `X ... Y`             | Yes        | No            |                                      |
|      | `CLLocationCoordinate2D` | `String` | List                  | No         | `coordinates` |                                      |
|      | `BinaryFloatingPoint`    | `String` | Latitude              | No         | `latitude`    | Including hemisphere                 |
|      | `BinaryFloatingPoint`    | `String` | Longitude             | No         | `longitude`   | Including hemisphere                 |
|      | `Any`                    | `String` | Description           | No         | `describing`  | Uses `String(describing:)`           |
|      | `Any`                    | `String` | Dump                  | No         | `dumped`      | Uses `dump()`                        |
|      | `DataProtocol`           | `String` | Hex-dumped            | No         | `hexdumped`   |                                      |
|      | `Codable`                | `String` | JSON                  | Yes        | `json`        | Uses `JSONEncoder` and `JSONDecoder` |
|      | `SIMD3<Float>`           | `String` | List (7)              | Yes        | TODO          | TODO: Placeholder implementation     |
|      | `BinaryInteger`          | `String` | Radixed format        | No         | Various       | Binary, Octal, Hex representations   |

### Notes

1: Type provided as `FormatInput` in the `FormatStyle` implementation.
2: Type provided as `FormatOutput` in the `FormatStyle` implementation.
3: Format of the output.
4: Whether the `FormatStyle` implementation provides a corresponding `ParserStrategy`.
5: Whether a convenience property is provided to access style on `FormatStyle`.
6: Formats the input as a comma-separated list.

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
- [ ] Investigate a "Parsable" and "Formattable" protocol that provides a .formatted() etc functions.

## Resources

### Apple

- <https://developer.apple.com/documentation/foundation/formatstyle>
- <https://developer.apple.com/documentation/foundation/parseableformatstyle>
- <https://developer.apple.com/documentation/foundation/floatingpointformatstyle>

### Other

- <https://fuckingformatstyle.com>
