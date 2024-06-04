//
//  KalmanFilter.swift
//
//
//  Created by Pfriedrix on 12.05.2024.
//

class DimensionalKalmanFilter {
    private var qValue: Double
    private var initialRValue: Double
    private var x: Double
    private var p: Double
    private var k: Double
    
    init(initialValue: Double, processNoise: Double, measurementNoise: Double) {
        self.qValue = processNoise
        self.initialRValue = measurementNoise
        self.x = initialValue
        self.p = 1.0
        self.k = 0.0
    }
    
    func update(value: Double, accuracy: CoordinateAccuracy) -> Double {
        let rValue = max(initialRValue, accuracy)
        
        p = p + qValue
        k = p / (p + rValue)
        x = x + k * (value - x)
        p = (1 - k) * p 
        
        return x
    }
}

public struct KalmanFilter: Filter {
    private var latitudeFilter: DimensionalKalmanFilter
    private var longitudeFilter: DimensionalKalmanFilter
    private var altitudeFilter: DimensionalKalmanFilter
    
    public init(initial location: Location, processNoise: Double, measurementNoise: Double) {
        latitudeFilter = DimensionalKalmanFilter(initialValue: location.coordinate.latitude, processNoise: processNoise, measurementNoise: measurementNoise)
        longitudeFilter = DimensionalKalmanFilter(initialValue: location.coordinate.longitude, processNoise: processNoise, measurementNoise: measurementNoise)
        altitudeFilter = DimensionalKalmanFilter(initialValue: location.altitude, processNoise: processNoise / 5, measurementNoise: measurementNoise)
    }
    
    public func filter(of data: [Location]) -> [Location] {
        var filteredData = [Location]()
        for var location in data {
            let filteredLatitude = latitudeFilter.update(value: location.coordinate.latitude, accuracy: location.accuracy.horizontal)
            let filteredLongitude = longitudeFilter.update(value: location.coordinate.longitude, accuracy: location.accuracy.horizontal)
            let filteredAltitude = altitudeFilter.update(value: location.altitude, accuracy: location.accuracy.vertical)
            location.coordinate.longitude = filteredLongitude
            location.coordinate.latitude = filteredLatitude
            location.altitude = filteredAltitude
            filteredData.append(location)
        }
        return filteredData
    }
}
