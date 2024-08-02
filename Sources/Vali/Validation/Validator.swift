//
//  Validator.swift
//
//
//  Created by Pfriedrix on 11.03.2024.
//

public protocol Validator {
    associatedtype Body: Validator

    func validate() -> Validated
    @ValidatorBuilder var body: Body { get }
}

extension Never: Validator {
    public typealias Body = Never
    public var body: Never {
        fatalError(
                  """
                  '\(Self.self)' has no body. …
                  
                  Do not try to access a validator's 'body' property directly, as it may not exist.
                  """
        )
    }
}

extension Validator where Body == Never {
    public func validate() -> Validated {
        .valid
    }
}

extension Validator where Body: Validator {
    public func validate() -> Validated {
        body.validate()
    }
}

extension ConditionValidator where Self: Validator {
    var body: Never {
        fatalError(
                  """
                  '\(Self.self)' has no body. …
                  
                  Do not try to access a validator's 'body' property directly, as it may not exist.
                  """
        )
    }
}

extension RangeValidator where Self: Validator {
    public var body: Never {
        fatalError(
                  """
                  '\(Self.self)' has no body. …
                  
                  Do not try to access a validator's 'body' property directly, as it may not exist.
                  """
        )
    }
}

extension TupleValidator where Self: Validator {
    var body: Never {
        fatalError(
                  """
                  '\(Self.self)' has no body. …
                  
                  Do not try to access a validator's 'body' property directly, as it may not exist.
                  """
        )
    }
}

extension EmptyValidator {
    public var body: Never {
        fatalError(
                  """
                  '\(Self.self)' has no body. …
                  
                  Do not try to access a validator's 'body' property directly, as it may not exist.
                  """
        )
    }
}

extension Optional where Self: Validator {
    public var body: Never {
        fatalError(
                  """
                  '\(Self.self)' has no body. …
                  
                  Do not try to access a validator's 'body' property directly, as it may not exist.
                  """
        )
    }
}

extension GroupValidator where Self: Validator {
    var body: Never {
        fatalError(
                  """
                  '\(Self.self)' has no body. …
                  
                  Do not try to access a validator's 'body' property directly, as it may not exist.
                  """
        )
    }
}
