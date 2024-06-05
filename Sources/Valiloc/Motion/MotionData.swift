//
//  MotionData.swift
//
//
//  Created by Pfriedrix on 04.06.2024.
//

import Foundation

public struct MotionData: Codable {
    public var acceleration: Acceleration?
    public var rotationRate: RotationRate?
    public var pedometer: PedometerData?
    public var altitude: AltitudeData?
    public var timestamp: TimeInterval
    
    public init(acceleration: Acceleration? = nil, rotationRate: RotationRate? = nil, pedometer: PedometerData? = nil, altitude: AltitudeData? = nil, timestamp: TimeInterval) {
        self.acceleration = acceleration
        self.rotationRate = rotationRate
        self.pedometer = pedometer
        self.altitude = altitude
        self.timestamp = timestamp
    }
}
