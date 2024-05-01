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
    
    func validate() -> Bool {
        Mirror(reflecting: value)
            .children
            .compactMap {
                $0.value as? any Validator
            }
            .allSatisfy { $0.validate() }
    }
}
