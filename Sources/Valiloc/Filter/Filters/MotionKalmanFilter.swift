//
//  MotionKalmanFilter.swift
//
//
//  Created by Pfriedrix on 05.06.2024.
//

public struct MotionKalmanFilter: Filter {
    private var pedometerCurrentPaceFilter: DimensionalKalmanFilter?
    private var altitudeFilter: DimensionalKalmanFilter?
    
    public init(initial motionData: MotionData, processNoise: Double, measurementNoise: Double) {
        if let pedometer = motionData.pedometer {
            pedometerCurrentPaceFilter = DimensionalKalmanFilter(initialValue: pedometer.currentPace, processNoise: processNoise, measurementNoise: measurementNoise)
        }
        if let altitude = motionData.altitude {
            altitudeFilter = DimensionalKalmanFilter(initialValue: altitude.altitude, processNoise: processNoise / 5, measurementNoise: measurementNoise)
        }
    }
    
    public func filter(of data: [MotionData]) -> [MotionData] {
        var filteredData = [MotionData]()
        for var motionData in data {
            if let pedometer = motionData.pedometer, let altitude = motionData.altitude {
                if let pedometerCurrentPaceFilter = pedometerCurrentPaceFilter {
                    let filteredCurrentPace = pedometerCurrentPaceFilter.update(value: pedometer.currentPace)
                    motionData.pedometer?.currentPace = filteredCurrentPace
                }
                if let altitudeFilter = altitudeFilter {
                    let filteredAltitude = altitudeFilter.update(value: altitude.altitude, accuracy: altitude.accuracy)
                    motionData.altitude?.altitude = filteredAltitude
                }
                filteredData.append(motionData)
            }
        }
        return filteredData
    }
}
