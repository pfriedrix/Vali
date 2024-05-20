//
//  Coordinate.swift
//  
//
//  Created by Pfriedrix on 11.03.2024.
//

public struct Coordinate: Codable {
    public var latitude: Distance
    public var longitude: Distance
    
    public init(latitude: Distance, longitude: Distance) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

public extension Coordinate {
    static var zero: Coordinate {
        .init(latitude: .zero, longitude: .zero)
    }
}
