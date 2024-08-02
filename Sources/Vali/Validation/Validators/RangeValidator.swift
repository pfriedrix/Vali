//
//  RangeValidator.swift
//
//
//  Created by Pfriedrix on 20.03.2024.
//

public enum RangeError: Error {
    case rangeOut(String)
}

public struct RangeValidator<T, Value, Range: RangeExpression>: Validator where Value: Comparable, Range.Bound == Value {
    let range: Range
    let value: Value
    let keyPath: KeyPath<T, Value>
    
    public init(with range: Range, for value: Value, keyPath: KeyPath<T, Value>) {
        self.range = range
        self.value = value
        self.keyPath = keyPath
    }

    public func validate() -> Validated {
        if range.contains(value) {
            return .valid
        } else {
            return .invalid(CompositeError(errors: [DetailedError(message: "Value out of range: \(value)", keyPath: keyPath)]))
        }
    }
}
