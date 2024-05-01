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
    
    func validate() -> Bool {
        validators.allSatisfy { $0.validate() }
    }
}
