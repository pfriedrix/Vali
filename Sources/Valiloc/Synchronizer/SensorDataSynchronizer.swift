//
//  SensorDataSynchronizer.swift
//
//
//  Created by Pfriedrix on 05.06.2024.
//

import Foundation

public struct SensorDataSynchronizer {
    private var locations: [Location] = []
    private var motionData: [MotionData] = []
    
    private let synchronizationTolerance: TimeInterval
    
    /// m/s
    private let speedTolerance: Double = 1.0
    private let altitudeTolerance: Double = 5.0
    
    public init(synchronizationTolerance: TimeInterval = 0.5) {
        self.synchronizationTolerance = synchronizationTolerance
    }
    
    public mutating func addLocationData(_ locations: [Location]) {
        self.locations.append(contentsOf: locations)
        self.locations.sort { $0.timestamp < $1.timestamp }
    }
    
    public mutating func addMotionData(_ motions: [MotionData]) {
        motionData.append(contentsOf: motions)
        motionData.sort { $0.timestamp < $1.timestamp }
    }
    
    private func synchronizeData() -> [SynchronizedSensorData] {
        var synchronizedData: [SynchronizedSensorData] = []
        for (motion, location) in zip(motionData, locations) {
            synchronizedData.append(SynchronizedSensorData(location: location, motion: motion))
        }
        return synchronizedData
    }
    
    public func crossValidateAndCorrectData() -> [Location] {
        var correctedLocations: [Location] = []
        var previousLocation: Location? = nil
        
        for synchronizedData in synchronizeData() {
            var correctedLocation = synchronizedData.location
            if let motion = synchronizedData.motion {
                if let pedometerSpeed = motion.pedometer?.speed {
                    correctedLocation.speed = pedometerSpeed
                }
                
                if let altitude = motion.altitude {
                    let gpsAltitude = correctedLocation.altitude
                    let gpsAccuracy = correctedLocation.accuracy.vertical
                    let barAccuracy = altitude.accuracy
                    
                    if gpsAccuracy <= altitudeTolerance && barAccuracy <= altitudeTolerance {
                        let gpsWeight = 1.0 / gpsAccuracy
                        let barWeight = 1.0 / barAccuracy
                        let totalWeight = gpsWeight + barWeight
                        correctedLocation.altitude = (gpsAltitude * gpsWeight + altitude.altitude * barWeight) / totalWeight
                    } else if barAccuracy <= altitudeTolerance {
                        correctedLocation.altitude = altitude.altitude
                    }
                }
                
                /// static movement
                if let acceleration = motion.acceleration, acceleration.magnitude < 0.1,
                   let rotationRate = motion.rotationRate, rotationRate.magnitude < 0.1,
                   let previousLocation = previousLocation {
                    if correctedLocation.distance(from: previousLocation) > 1.0 {
                        correctedLocation.coordinate = previousLocation.coordinate
                    }
                }
            }
            
            correctedLocations.append(correctedLocation)
            previousLocation = correctedLocation
            
        }
        
        return correctedLocations
    }
}
