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
        var motionIndex = 0
        
        for location in locations {
            let gpsTimestamp = location.timestamp.timeIntervalSince1970
            
            var left = 0
            var right = motionData.count - 1
            while left <= right {
                let mid = (left + right) / 2
                let motionTimestamp = motionData[mid].timestamp
                if abs(motionTimestamp - gpsTimestamp) <= synchronizationTolerance {
                    motionIndex = mid
                    break
                } else if motionTimestamp < gpsTimestamp {
                    left = mid + 1
                } else {
                    right = mid - 1
                }
            }
            
            let motion = motionIndex < motionData.count ? motionData[motionIndex] : nil
            if let motion = motion {
                synchronizedData.append(SynchronizedSensorData(location: location, motion: motion))
            } else {
                synchronizedData.append(SynchronizedSensorData(location: location, motion: nil))
            }
        }
        
        return synchronizedData
    }
    
    // m/s
    private func calculateSpeed(from acceleration: Acceleration?, previousAcceleration: Acceleration?) -> Double? {
        guard let acceleration = acceleration, let previousAcceleration = previousAcceleration else {
            return nil // Немає попередніх даних для розрахунку швидкості
        }
        
        // Вираховуємо гравітацію (припускаючи, що пристрій переважно вертикальний)
        let accelerationWithoutGravity = Acceleration(x: acceleration.x, y: acceleration.y, z: acceleration.z - 1.0, timestamp: acceleration.timestamp)
        
        // Інтегруємо прискорення для отримання швидкості
        let timeInterval = acceleration.timestamp - previousAcceleration.timestamp
        let velocityX = accelerationWithoutGravity.x * timeInterval
        let velocityY = accelerationWithoutGravity.y * timeInterval
        
        let speed = sqrt(velocityX * velocityX + velocityY * velocityY)
        
        return speed
    }
    
    public func crossValidateAndCorrectData() -> [Location] {
        var correctedLocations: [Location] = []
        var previousLocation: Location? = nil
        var previousAcceleration: Acceleration? = nil
        
        for synchronizedData in synchronizeData() {
            var correctedLocation = synchronizedData.location
            
            if let motion = synchronizedData.motion {
                let gpsWeight = 1.0 / max(correctedLocation.accuracy.horizontal, 1.0)
                let accelerometerWeight = 0.5
                let barometerWeight = 0.2
                
                if let accelerometerSpeed = calculateSpeed(from: motion.acceleration, previousAcceleration: previousAcceleration) {
                    let gpsSpeed = correctedLocation.speed
                    let combinedSpeed = (gpsSpeed * gpsWeight + accelerometerSpeed * accelerometerWeight) / (gpsWeight + accelerometerWeight)
                    if abs(gpsSpeed - accelerometerSpeed) > speedTolerance {
                        correctedLocation.speed = combinedSpeed
                    }
                }
                
                if let barAltitude = motion.altitude?.altitude {
                    let locationAltitude = correctedLocation.altitude
                    let combinedAltitude = (locationAltitude * gpsWeight + barAltitude * barometerWeight) / (gpsWeight + barometerWeight)
                    if abs(locationAltitude - barAltitude) > altitudeTolerance {
                        correctedLocation.altitude = combinedAltitude
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
                previousAcceleration = synchronizedData.motion?.acceleration
            }
            
            correctedLocations.append(correctedLocation)
            previousLocation = correctedLocation

        }
        
        return correctedLocations
    }
}
