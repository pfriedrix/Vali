//
//  File.swift
//  
//
//  Created by Pfriedrix on 01.05.2024.
//

public enum Validated {
    case valid
    case invalid(Array<Error>)
}

extension Validated: Equatable {
    public static func == (lhs: Validated, rhs: Validated) -> Bool {
        switch (lhs, rhs) {
        case (.valid, .valid): return true
        case (.invalid(_), .invalid(_)): return true
        default: return false
        }
    }
}
