//
//  Measurer.swift
//
//
//  Created by Pfriedrix on 25.03.2024.
//

public protocol Measurer {
    associatedtype F: Filter
    var filter: F { get }
}
