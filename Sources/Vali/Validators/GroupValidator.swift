//
//  GroupValidator.swift
//
//
//  Created by Pfriedrix on 01.05.2024.
//

public struct GroupValidator<V> where V: Validator {
    let validators: [V]
}

extension GroupValidator: Validator {
    public typealias Body = Never
    
    public func validate() -> Validated {
        let errors = validators.flatMap { validator -> [ValidationError] in
            switch validator.validate() {
            case .valid:
                return []
            case .invalid(let compositeError):
                return compositeError.errors
            }
        }
        
        return errors.isEmpty ? .valid : .invalid(CompositeError(errors: errors))
    }
}
