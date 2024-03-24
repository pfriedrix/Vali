//
//  File.swift
//
//
//  Created by Pfriedrix on 21.03.2024.
//

import XCTest
@testable import Valiloc

final class LocationTest: XCTestCase {

    func testlocationBuildValidator() throws {
        let locations = try Location.loadMocks()
        XCTAssertFalse(locations.isEmpty)
        
        let result = locations.compactMap {
            let result = LocationValidator(location: $0).validate()
            return result ? nil : $0
        }
        
        print(result.first, result.count, locations.count)
        
        XCTAssertTrue(result.isEmpty)
    }
}

struct LocationValidator: Validator {
    let location: Location
    var body: some Validator {
        Validate {
            AccuracyValidator(accuracy: location.accuracy)
            SpeedValidator(speed: location.speed)
        }
    }
}

struct AccuracyValidator: Validator {
    let accuracy: Accuracy
    
    var body: some Validator {
        Validate {
            RangeValidator(with: 0...10, for: accuracy.horizontal)
            RangeValidator(with: 0...10, for: accuracy.vertical)
            RangeValidator(with: 0...2, for: accuracy.speed)
            RangeValidator(with: 0..., for: accuracy.course)
        }
    }
}

struct SpeedValidator: Validator {
    let speed: Speed
    
    var body: some Validator {
        Validate {
            RangeValidator(with: 1...30, for: speed)
        }
    }
}
