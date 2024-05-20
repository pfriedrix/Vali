//
//  Accuracy.swift
//  
//
//  Created by Pfriedrix on 11.03.2024.
//

/*
 *  DirectionAccuracy
 *
 *  Discussion:
 *    Type used to represent a direction accuracy in degrees.  The lower the value the more precise the
 *    direction is.  A negative accuracy value indicates an invalid direction.
 */
public typealias DirectionAccuracy = Double

/*
 *  SpeedAccuracy
 *
 *  Discussion:
 *    Type used to represent the direction in degrees from 0 to 359.9. A negative value indicates an
 *    invalid direction.
 */
public typealias SpeedAccuracy = Double

/*
 *  CoordinateAccuracy
 *
 *  Discussion:
 *    Type used to represent a location accuracy level in meters. The lower the value in meters, the
 *    more physically precise the location is. A negative accuracy value indicates an invalid location.
 */
public typealias CoordinateAccuracy = Double

public struct Accuracy: Codable {
    public var horizontal: CoordinateAccuracy
    public var vertical: CoordinateAccuracy
    public var course: DirectionAccuracy
    public var speed: SpeedAccuracy
    
    public init(horizontal: CoordinateAccuracy, vertical: CoordinateAccuracy, course: DirectionAccuracy, speed: SpeedAccuracy) {
        self.horizontal = horizontal
        self.vertical = vertical
        self.course = course
        self.speed = speed
    }
}

public extension Accuracy {
    static var zero: Accuracy {
        .init(horizontal: .zero, vertical: .zero, course: .zero, speed: .zero)
    }
}
