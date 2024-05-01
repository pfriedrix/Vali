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
        let errors = validators.flatMap { validator -> [Error] in
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
