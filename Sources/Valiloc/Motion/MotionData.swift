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
}
