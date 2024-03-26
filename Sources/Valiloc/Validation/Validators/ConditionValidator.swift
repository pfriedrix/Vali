//
//  ConditionValidator.swift
//  
//
//  Created by Pfriedrix on 20.03.2024.
//

@frozen public struct ConditionValidator<T: Validator, F: Validator>: Validator {
    private let first: T?
    private let second: F?
    
    public init(first: T? = nil, second: F? = nil) {
        self.first = first
        self.second = second
    }
    
    public func validate() -> Bool {
        if let first = first {
            return first.validate()
        } else if let second = second {
            return second.validate()
        }
        return true
    }
    
    public typealias Body = Never
}
