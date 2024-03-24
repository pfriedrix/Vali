//
//  RangeValidator.swift
//
//
//  Created by Pfriedrix on 20.03.2024.
//

@frozen public struct RangeValidator<Data: Comparable, Range: RangeExpression>: Validator where Range.Bound == Data {
    public typealias Body = Never
    
    private let range: Range
    private let data: Data

    public init(with range: Range, for data: Data) {
        self.range = range
        self.data = data
    }
    
    public func validate() -> Bool {
        range.contains(data)
    }
}

