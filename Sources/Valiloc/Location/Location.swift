//
//  Location.swift
//
//
//  Created by Pfriedrix on 11.03.2024.
//

import Foundation

public struct Location: Codable {
    var coordinate: Coordinate
    var accuracy: Accuracy
    var speed: Speed
    var altitude: Distance
    var timestamp: Date
    var sourceInfomation: SourceInformation?
    
    public init(coordinate: Coordinate, accuracy: Accuracy, speed: Speed, altitude: Distance, timestamp: Date, sourceInfomation: SourceInformation? = nil) {
        self.coordinate = coordinate
        self.accuracy = accuracy
        self.speed = speed
        self.altitude = altitude
        self.timestamp = timestamp
        self.sourceInfomation = sourceInfomation
    }
}

/*
 *  CLLocationDistance
 *
 *  Discussion:
 *    Type used to represent a distance in meters.
 */
public typealias Distance = Double

/*
 *  CLLocationSpeed
 *
 *  Discussion:
 *    Type used to represent the speed in meters per second.
 */
public typealias Speed = Double

/*
 *  CLLocationDirectionAccuracy
 *
 *  Discussion:
 *    Type used to represent a direction accuracy in degrees.  The lower the value the more precise the
 *    direction is.  A negative accuracy value indicates an invalid direction.
 */
public typealias Direction = Double

// MARK: - MOCKED DATA
extension Location {
    public static func loadMocks() throws -> [Location] {
        guard let fileURL = Bundle.module.url(forResource: "locations", withExtension: "json") else {
            throw NSError(domain: "no file", code: 1)
        }
        
        let jsonData = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        let locations = try decoder.decode([Location].self, from: jsonData)
        return locations
    }
}
