//
//  KalmanFilter.swift
//
//
//  Created by Pfriedrix on 20.05.2024.
//

import XCTest
@testable import Valiloc

final class KalmanFilterTests: XCTestCase {
    var kalmanFilter: LocationKalmanFilter!
    var mockLocations: [Location] = []
    
    override func setUp() {
        super.setUp()
//        mockLocations = (try? Location.loadMocks()) ?? []
        
        if let initialLocation = mockLocations.first {
            kalmanFilter = LocationKalmanFilter(initial: initialLocation, processNoise: 0.01, measurementNoise: 0.1)
        }
    }
    
    override func tearDown() {
        kalmanFilter = nil
        mockLocations = []
        super.tearDown()
    }
    
    func testKalmanFilterAccuracy() {
        guard let _ = kalmanFilter else {
            XCTFail("Kalman filter was not initialized")
            return
        }
        
        let filteredLocations = kalmanFilter.filter(of: mockLocations)
        
        for (filtered, original) in zip(filteredLocations, mockLocations) {
            XCTAssertEqual(filtered.coordinate.latitude, original.coordinate.latitude, accuracy: 0.1, "Filtered latitude is not accurate")
            XCTAssertEqual(filtered.coordinate.longitude, original.coordinate.longitude, accuracy: 0.1, "Filtered longitude is not accurate")
        }
    }
    
    func testStabilityOfFilter() {
        guard let _ = kalmanFilter else {
            XCTFail("Kalman filter was not initialized")
            return
        }
        
        var currentLocations = mockLocations
        for _ in 1...4 {
            currentLocations = kalmanFilter.filter(of: currentLocations)
        }
        
        let lastLocation = currentLocations.last
        XCTAssertNotNil(lastLocation, "No location available after filtering")

        if let expectedLatitude = lastLocation?.coordinate.latitude, let expectedLongitude = lastLocation?.coordinate.longitude {
            XCTAssertEqual(expectedLatitude, 50.37926231758622, accuracy: 0.001, "Filter is not stable for latitude")
            XCTAssertEqual(expectedLongitude, 30.479193768346438, accuracy: 0.001, "Filter is not stable for longitude")
        }
    }
}
