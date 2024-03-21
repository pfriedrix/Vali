//
//  Validator.swift
//
//
//  Created by Pfriedrix on 11.03.2024.
//

public protocol Validator {
    associatedtype Body
    
    func validate() -> Bool
    
    @ValidatorBuilder var body: Self.Body { get }
}

extension Validator where Body == Never {
    public var body: Body {
        fatalError(
          """
          '\(Self.self)' has no body. …

          Do not try to access a validaot's 'body' property directly, as it may not exist.
          """
        )
    }
}

extension Validator where Body: Validator {
    public func validate() -> Bool {
        body.validate()
    }
}
