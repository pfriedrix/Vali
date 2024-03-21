//
//  Accuracy.swift
//  
//
//  Created by Pfriedrix on 11.03.2024.
//

public typealias DirectionAccuracy = Double
public typealias SpeedAccuracy = Double
public typealias Accuracy = Double

public struct LocationAccuracy {
    let horizontal: Accuracy
    let vertical: Accuracy
    let course: DirectionAccuracy
}

public extension LocationAccuracy {
    static var zero: LocationAccuracy {
        .init(horizontal: .zero, vertical: .zero, course: .zero)
    }
}
