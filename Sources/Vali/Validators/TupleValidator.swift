//
//  TupleValidator.swift
//
//
//  Created by Pfriedrix on 20.03.2024.
//

public struct TupleValidator<V>: Validator {
    public typealias Body = Never
    
    let validators: V
    
    init(_ value: V) {
        validators = value
    }
    
    public func validate() -> Validated {
        var errors: [ValidationError] = []

        for validator in Mirror(reflecting: validators).children.compactMap({ $0.value as? any Validator }) {
            let validation = validator.validate()
            if case .invalid(let error) = validation {
                errors.append(error)
            }
        }

        if errors.isEmpty {
            return .valid
        } else {
            return .invalid(CompositeError(errors: errors))
        }
    }
}
