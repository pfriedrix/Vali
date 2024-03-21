//
//  Coordinate.swift
//  
//
//  Created by Pfriedrix on 11.03.2024.
//

public struct Coordinate {
    var latitude: Distance
    var longitude: Distance
}

public extension Coordinate {
    static var zero: Coordinate {
        .init(latitude: .zero, longitude: .zero)
    }
}
