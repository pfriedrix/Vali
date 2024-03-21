//
//  Location.swift
//
//
//  Created by Pfriedrix on 11.03.2024.
//

public struct Location {
    var coordinate: Coordinate
    let accuracy: Accuracy = .zero
    var speed: Speed
}

public typealias Distance = Double
public typealias Speed = Double
public typealias Direction = Double
