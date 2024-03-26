//
//  LocationFilter.swift
//  
//
//  Created by Pfriedrix on 25.03.2024.
//


public struct LocationFilter: Filter {
    public func filter(of data: [Location]) -> [Location] {
        data.filter { LocationValidator(location: $0).validate() }
    }
}

struct LocationValidator: Validator {
    private let location: Location
    
    public init(location: Location) {
        self.location = location
    }
    
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
