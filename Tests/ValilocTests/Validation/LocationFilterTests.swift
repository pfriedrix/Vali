//
//  LocationFilter.swift
//  Valiloc
//
//  Created by Pfriedrix on 18.07.2024.
//

import XCTest
@testable import Valiloc

final class LocationFilterTests: XCTestCase {
    func testLocationFilter() {
        // Create test data
        let locations = [
                    Location(coordinate: Coordinate(latitude: 37.7749, longitude: -122.4194),
                             accuracy: Accuracy(horizontal: 5, vertical: 8, course: 0, speed: 1.5),
                             speed: 20,
                             altitude: 100,
                             timestamp: Date().timeIntervalSince1970,
                             course: 0,
                             sourceInfomation: nil),
                    
                    Location(coordinate: Coordinate(latitude: 37.7749, longitude: -122.4194),
                             accuracy: Accuracy(horizontal: 15, vertical: 8, course: 0, speed: 1.5),
                             speed: 50,
                             altitude: 100,
                             timestamp: Date().timeIntervalSince1970,
                             course: 0,
                             sourceInfomation: nil),
                    
                    Location(coordinate: Coordinate(latitude: 37.7749, longitude: -122.4194),
                             accuracy: Accuracy(horizontal: 5, vertical: 15, course: 0, speed: 3.5),
                             speed: 30,
                             altitude: 100,
                             timestamp: Date().timeIntervalSince1970,
                             course: 0,
                             sourceInfomation: nil),
                    
                    Location(coordinate: Coordinate(latitude: 37.7749, longitude: -122.4194),
                             accuracy: Accuracy(horizontal: 5, vertical: 8, course: 0, speed: 1.5),
                             speed: 35,
                             altitude: 100,
                             timestamp: Date().timeIntervalSince1970,
                             course: 0,
                             sourceInfomation: nil)
                ]
        
        // Create an instance of LocationFilter
        let filter = LocationFilter()
        
        let validLocations = filter.filter(of: locations)
        
        // Assert the results
        XCTAssertEqual(validLocations.count, 2, "There should be 2 valid location")
        
        if let validLocation = validLocations.first {
            XCTAssertEqual(validLocation.speed, 20, "The speed of the valid location should be 20")
        }
        
        // Example filtering by keyPath
        let filteredSpeeds = filter.filter(of: locations, for: \.accuracy.horizontal)
        
        // Assert the filtered speeds
        XCTAssertEqual(filteredSpeeds.count, 3, "There should be one valid speed")
    }
    
}
