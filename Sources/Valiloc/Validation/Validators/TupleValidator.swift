//
//  TupleValidator.swift
//  
//
//  Created by Pfriedrix on 20.03.2024.
//

@frozen public struct TupleValidator<V>: Validator {
    public typealias Body = Never
    
    public var value: V

    public init(_ value: V) {
        self.value = value
    }
    
    public func validate() -> Bool {
        Mirror(reflecting: value)
            .children
            .compactMap {
                $0.value as? any Validator
            }
            .allSatisfy { $0.validate() }
    }
}
