//
//  ValidationError.swift
//  Valiloc
//
//  Created by Pfriedrix on 18.07.2024.
//

public protocol ValidationError: Error {
    var message: String { get }
    var keyPath: AnyKeyPath { get }
}

public struct CompositeError: ValidationError {
    public var errors: [ValidationError]
    
    public init(errors: [ValidationError]) {
        self.errors = errors
    }
    
    public var message: String {
        return errors.map { $0.message }.joined(separator: ", ")
    }
    
    public var keyPath: AnyKeyPath {
        return errors.first?.keyPath ?? \Self.errors 
    }
}

public struct DetailedError<T, V>: ValidationError {
    public var message: String
    public var keyPath: AnyKeyPath
    
    public var keyPathDescription: String {
        return "\(keyPath)"
    }

    public init(message: String, keyPath: KeyPath<T, V>) {
        self.message = message
        self.keyPath = keyPath
    }
}
