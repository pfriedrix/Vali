//
//  MotionData.swift
//
//
//  Created by Pfriedrix on 04.06.2024.
//

public struct MotionData: Codable {
    public var acceleration: Acceleration?
    public var rotationRate: RotationRate?
    public var pedometer: PedometerData?
    public var altitude: AltitudeData?
    
    public init(acceleration: Acceleration? = nil, rotationRate: RotationRate? = nil, pedometer: PedometerData? = nil, altitude: AltitudeData? = nil) {
        self.acceleration = acceleration
        self.rotationRate = rotationRate
        self.pedometer = pedometer
        self.altitude = altitude
    }
}
