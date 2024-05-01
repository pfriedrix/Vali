//
//  TupleValidator.swift
//
//
//  Created by Pfriedrix on 20.03.2024.
//

struct TupleValidator<V>: Validator {
    typealias Body = Never
    
    let value: V
    
    init(_ value: V) {
        self.value = value
    }
    
    func validate() -> Validated {
        let errors = Mirror(reflecting: value)
            .children
            .compactMap { $0.value as? any Validator }
            .flatMap { validator -> [Error] in
                switch validator.validate() {
                case .valid:
                    return []
                case .invalid(let validationErrors):
                    return validationErrors
                }
            }
        return errors.isEmpty ? .valid : .invalid(errors)
    }
}
