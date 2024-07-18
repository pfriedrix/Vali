//
//  File.swift
//  
//
//  Created by Pfriedrix on 04.06.2024.
//

import Foundation

public struct AltitudeData: Codable {
    /*
     *  altitude
     *
     *  Discussion:
     *    The absolute altitude of the device in meters relative to sea level; could be positive or negative.
     *
     */
    public var altitude: Double
    
    /*
     *  accuracy
     *
     *  Discussion:
     *    The accuracy of the altitude estimate, in meters.
     *
     */
    public var accuracy: Double
    
    /*
     *  precision
     *
     *  Discussion:
     *    The precision of the altitude estimate, in meters.
     *
     */
    public var precision: Double
    
    public let timestamp: TimeInterval
    
    public init(altitude: Double, accuracy: Double, precision: Double, timestamp: TimeInterval) {
        self.altitude = altitude
        self.accuracy = accuracy
        self.precision = precision
        self.timestamp = timestamp
    }
}
