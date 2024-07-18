//
//  Validated.swift
//  
//
//  Created by Pfriedrix on 01.05.2024.
//

public enum Validated {
    case valid
    case invalid(CompositeError)
}

extension Validated: Equatable {
    public static func == (lhs: Validated, rhs: Validated) -> Bool {
        switch (lhs, rhs) {
        case (.valid, .valid):
            return true
        case (.invalid(let lhsError), .invalid(let rhsError)):
            return lhsError.message == rhsError.message
        default:
            return false
        }
    }
}
