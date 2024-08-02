//
//  GroupValidator.swift
//
//
//  Created by Pfriedrix on 01.05.2024.
//

struct GroupValidator<V> where V: Validator {
    let validators: [V]
}

extension GroupValidator: Validator {
    typealias Body = Never
    
    func validate() -> Validated {
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
