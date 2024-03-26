//
//  LocationMeasurer.swift
//
//
//  Created by Pfriedrix on 25.03.2024.
//

import Foundation

public struct LocationMeasurer: Measurer {
    public let filter: LocationFilter
    
    public func distance(of data: [Location], for unit: UnitLength = .meters) -> Measurement<UnitLength> {
        let locations = filter.filter(of: data)
        let distance = zip(locations, locations.dropFirst()).reduce(0) {
            $0 + $1.0.distance(from: $1.1)
        }
        let meters = Measurement(value: distance, unit: UnitLength.meters)
        return meters.converted(to: unit)
    }
    
    public func averageSpeed(of data: [Location], for unit: UnitSpeed = .metersPerSecond) -> Measurement<UnitSpeed> {
        let locations = filter.filter(of: data)
        let speeds = locations.reduce(0) { $0 + $1.speed }
        let value = speeds > 0 ? speeds / Double(locations.count) : 0
        let metersPerSecond = Measurement(value: value, unit: UnitSpeed.metersPerSecond)
        return metersPerSecond.converted(to: unit)
    }
    
    public func altitudeGain(of data: [Location], for unit: UnitLength = .meters) -> Measurement<UnitLength> {
        let locations = filter.filter(of: data)
        let changes = zip(locations, locations.dropFirst()).map { $1.altitude - $0.altitude }
        let netChange = changes.reduce(0, +)
        
        let meters = Measurement(value: netChange, unit: unit)
        return meters.converted(to: unit)
    }
}
