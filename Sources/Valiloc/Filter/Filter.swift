//
//  Filter.swift
//
//
//  Created by Pfriedrix on 26.03.2024.
//

public protocol Filter {
    associatedtype Item
    func filter(of data: [Item]) -> [Item]
}
