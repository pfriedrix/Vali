//
//  Location.swift
//
//
//  Created by Pfriedrix on 11.03.2024.
//

import CoreLocation

public struct Location: Codable {
    public var coordinate: Coordinate
    public var accuracy: Accuracy
    public var speed: Speed
    public var altitude: Distance
    public var timestamp: Date
    public var sourceInfomation: SourceInformation?
    
    public init(coordinate: Coordinate, accuracy: Accuracy, speed: Speed, altitude: Distance, timestamp: Date, sourceInfomation: SourceInformation? = nil) {
        self.coordinate = coordinate
        self.accuracy = accuracy
        self.speed = speed
        self.altitude = altitude
        self.timestamp = timestamp
        self.sourceInfomation = sourceInfomation
    }
}

/*
 *  Distance
 *
 *  Discussion:
 *    Type used to represent a distance in meters.
 */
public typealias Distance = Double

/*
 *  Speed
 *
 *  Discussion:
 *    Type used to represent the speed in meters per second.
 */
public typealias Speed = Double

/*
 *  Direction
 *
 *  Discussion:
 *    Type used to represent a direction accuracy in degrees.  The lower the value the more precise the
 *    direction is.  A negative accuracy value indicates an invalid direction.
 */
public typealias Direction = Double

// MARK: - CLLocation
extension Location {
    public init(from location: CLLocation) {
        self.coordinate = Coordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        self.accuracy = Accuracy(horizontal: location.horizontalAccuracy, vertical: location.verticalAccuracy, course: location.courseAccuracy, speed: location.speedAccuracy)
        self.speed = location.speed
        self.altitude = location.altitude
        self.timestamp = location.timestamp
        
        if #available(iOS 15.0, *) {
            self.sourceInfomation = SourceInformation(isPruducedByAccessory: location.sourceInformation?.isProducedByAccessory, isSimulatedBySoftware: location.sourceInformation?.isSimulatedBySoftware)
        } else {
            self.sourceInfomation = nil
        }
    }
}

extension CLLocation {
    convenience init(from location: Location) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let horizontalAccuracy = location.accuracy.horizontal
        let verticalAccuracy = location.accuracy.vertical
        let courseAccuracy = location.accuracy.course
        let speedAccuracy = location.accuracy.speed
        let speed = location.speed
        let altitude = location.altitude
        let timestamp = location.timestamp
 
        if #available(iOS 15.0, *) {
            guard let sourceInformation = CLLocationSourceInformation(softwareSimulationState: location.sourceInfomation?.isPruducedByAccessory, andExternalAccessoryState: location.sourceInfomation?.isSimulatedBySoftware) else {
                self.init(coordinate: coordinate, altitude: altitude, horizontalAccuracy: horizontalAccuracy, verticalAccuracy: verticalAccuracy, course: courseAccuracy, speed: speed, timestamp: timestamp)
                return
            }
            self.init(coordinate: coordinate, altitude: altitude, horizontalAccuracy: horizontalAccuracy, verticalAccuracy: verticalAccuracy, course: courseAccuracy, courseAccuracy: courseAccuracy, speed: speed, speedAccuracy: speedAccuracy, timestamp: timestamp, sourceInfo: sourceInformation)
        } else {
            self.init(coordinate: coordinate, altitude: altitude, horizontalAccuracy: horizontalAccuracy, verticalAccuracy: verticalAccuracy, course: courseAccuracy, speed: speed, timestamp: timestamp)
        }
    }
}

@available(iOS 15.0, *)
extension CLLocationSourceInformation {
    convenience init?(softwareSimulationState: Bool?, andExternalAccessoryState: Bool?) {
        guard let softwareSimulationState = softwareSimulationState, let andExternalAccessoryState = andExternalAccessoryState else {
            return nil
        }
        self.init(softwareSimulationState: softwareSimulationState, andExternalAccessoryState: andExternalAccessoryState)
    }
}

// MARK: - Measurement
extension Location {
    func distance(from location: Location) -> Distance {
        CLLocation(from: self).distance(from: CLLocation(from: location))
    }
}

// MARK: - MOCKED DATA
extension Location {
    public static func loadMocks() throws -> [Location] {
        let fileURL = Bundle.module.url(forResource: "locations", withExtension: "json")
        guard let fileURL = fileURL else {
            throw NSError(domain: "no file", code: 1)
        }
        
        let jsonData = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        let locations = try decoder.decode([Location].self, from: jsonData).sorted { $0.timestamp < $1.timestamp }
        return locations
    }
}
