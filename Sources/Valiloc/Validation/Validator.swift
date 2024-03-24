//
//  Validator.swift
//
//
//  Created by Pfriedrix on 11.03.2024.
//

import SwiftUI



public protocol Validator {
    associatedtype Body: Validator
    func validate() -> Bool
    
    @ValidatorBuilder var body: Body { get }
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

extension Never: Validator {
    public typealias Body = Never
    public var body: Never {
        fatalError()
    }
}

extension Validator where Body == Never {
    public func validate() -> Bool {
        true
    }
}

extension Validator where Body: Validator {
    public func validate() -> Bool {
        body.validate()
    }
}

