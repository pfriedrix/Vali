//
//  File.swift
//  
//
//  Created by Pfriedrix on 01.05.2024.
//

public struct GroupValidator<V> where V: Validator {
    let validators: [V]
}

extension GroupValidator: Validator {
    public typealias Body = Never
    
    public func validate() -> Bool {
        validators.allSatisfy { $0.validate() }
    }
}
