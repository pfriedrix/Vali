//
//  File.swift
//  
//
//  Created by Pfriedrix on 05.06.2024.
//

public struct SynchronizedSensorData: Codable {
    public let location: Location
    public let motion: MotionData?
}
