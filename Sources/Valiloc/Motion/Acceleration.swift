//
//  File.swift
//  
//
//  Created by Pfriedrix on 04.06.2024.
//

import Foundation

/// A G is a unit of gravitation force equal to that exerted by the earth’s gravitational field (9.81 m s−2).
public struct Acceleration: Codable {
    /// X-axis acceleration in G's (gravitational force).
    public let x: Double
    
    /// Y-axis acceleration in G's (gravitational force).
    public let y: Double
    
    /// Z-axis acceleration in G's (gravitational force).
    public let z: Double
    
    public let timestamp: TimeInterval
    
    public init(x: Double, y: Double, z: Double, timestamp: TimeInterval) {
        self.x = x
        self.y = y
        self.z = z
        self.timestamp = timestamp
    }
}
