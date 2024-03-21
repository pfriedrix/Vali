//
//  EmptyValidator.swift
//
//
//  Created by Pfriedrix on 20.03.2024.
//

@frozen public struct EmptyValidator: Validator {
    public func validate() -> Bool {
        return true
    }
}
