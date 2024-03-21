//
//  File.swift
//  
//
//  Created by Pfriedrix on 21.03.2024.
//

extension Optional: Validator where Wrapped: Validator {
    public func validate() -> Bool {
        switch self {
        case let .some(wrapped):
            return wrapped.validate()
        case .none:
            return true
        }
    }
}
