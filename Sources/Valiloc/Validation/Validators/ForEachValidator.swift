//
//  File.swift
//  
//
//  Created by Pfriedrix on 30.04.2024.
//

public struct ForEachValidator<Data, ID, V: Validator> where Data: RandomAccessCollection, ID: Hashable {
    public var data: Data
    public let validator: (Data.Element) -> V
}

extension ForEachValidator: Validator {
    public var body: some Validator {
        for element in data {
            validator(element)
        }
    }
}

extension ForEachValidator {
    public init(_ data: Data, id: KeyPath<Data.Element, ID>, @ValidatorBuilder validator: @escaping (Data.Element) -> V) {
        self.data = data
        self.validator = validator
    }
}
