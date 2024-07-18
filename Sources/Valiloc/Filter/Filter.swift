//
//  Filter.swift
//
//
//  Created by Pfriedrix on 26.03.2024.
//

public protocol Filter {
    associatedtype Item
    func filter(of data: [Item]) -> [Item]
    func filter<Value>(of data: [Item], for keyPath: KeyPath<Item, Value>) -> [Item]
}

extension Filter {
    public func filter<Value>(of data: [Item], for keyPath: KeyPath<Item, Value>) -> [Item] {
        fatalError("The method filter(of:for:) must be implemented by conforming types.")
    }
}
