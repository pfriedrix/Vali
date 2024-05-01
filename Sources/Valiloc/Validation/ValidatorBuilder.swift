//
//  ValidatorBuilder.swift
//
//
//  Created by Pfriedrix on 20.03.2024.
//

@resultBuilder
struct ValidatorBuilder {
    static func buildBlock() -> some Validator {
        EmptyValidator()
    }
    
    static func buildBlock<V: Validator>(_ validator: V) -> V {
        validator
    }
    
    static func buildBlock<each V>(_ validator: repeat each V) -> TupleValidator<(repeat each V)> where repeat each V: Validator {
        TupleValidator(nil ?? (repeat each validator))
    }
    
    static func buildExpression<V: Validator>(_ validator: V) -> V {
        validator
    }

    static func buildEither<T, F>(first validator: T) -> ConditionValidator<T, F> where T: Validator, F: Validator {
        ConditionValidator(first: validator)
    }
    
    static func buildOptional<V: Validator>(_ validator: V?) -> V? {
        validator
    }
    
    static func buildEither<T, F>(second validator: F) -> ConditionValidator<T, F> where T: Validator, F: Validator {
        ConditionValidator(second: validator)
    }
}
