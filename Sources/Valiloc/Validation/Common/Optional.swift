//
//  Optional.swift
//  
//
//  Created by Pfriedrix on 21.03.2024.
//

extension Optional: Validator where Wrapped: Validator {
    public typealias Body = Never
    
    public func validate() -> Validated {
        switch self {
        case let .some(wrapped):
            return wrapped.validate()
        case .none:
            return .valid
        }
    }
}
