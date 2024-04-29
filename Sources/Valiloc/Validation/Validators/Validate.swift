//
//  Validate.swift
//  
//
//  Created by Pfriedrix on 20.03.2024.
//

public struct Validate<V: Validator>: Validator {
    private let validator: () -> V
    
    public init(@ValidatorBuilder validator: @escaping () -> V) {
        self.validator = validator
    }
    
    public var body: V {
        validator()
    }
}
