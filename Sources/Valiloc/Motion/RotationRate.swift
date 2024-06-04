//
//  RotationRate.swift
//
//
//  Created by Pfriedrix on 04.06.2024.
//

import Foundation

/// The type of structures representing a measurement of rotation rate.
public struct RotationRate: Codable {
    
    /*
     *  RotationRate
     *
     *  Discussion:
     *    A structure containing 3-axis rotation rate data.
     *
     *  Fields:
     *    x:
     *      X-axis rotation rate in radians/second. The sign follows the right hand
     *      rule (i.e. if the right hand is wrapped around the X axis such that the
     *      tip of the thumb points toward positive X, a positive rotation is one
     *      toward the tips of the other 4 fingers).
     *    y:
     *      Y-axis rotation rate in radians/second. The sign follows the right hand
     *      rule (i.e. if the right hand is wrapped around the Y axis such that the
     *      tip of the thumb points toward positive Y, a positive rotation is one
     *      toward the tips of the other 4 fingers).
     *        z:
     *            Z-axis rotation rate in radians/second. The sign follows the right hand
     *      rule (i.e. if the right hand is wrapped around the Z axis such that the
     *      tip of the thumb points toward positive Z, a positive rotation is one
     *      toward the tips of the other 4 fingers).
     */
    
    /// The value for the X-axis.
    public let x: Double
    
    /// The value for the Y-axis.
    public let y: Double
    
    /// The value for the Z-axis.
    public let z: Double
    
    public let timestamp: TimeInterval
    
    public init(x: Double, y: Double, z: Double, timestamp: TimeInterval) {
        self.x = x
        self.y = y
        self.z = z
        self.timestamp = timestamp
    }
}
