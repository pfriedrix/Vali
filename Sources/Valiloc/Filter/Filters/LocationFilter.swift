//
//  LocationFilter.swift
//  
//
//  Created by Pfriedrix on 25.03.2024.
//

public struct LocationFilter: Filter {
    public init() { }
    
    public func filter<Value>(of data: [Location], for keyPath: KeyPath<Item, Value>) -> [Value] {
        data.filter {
            let result = LocationValidator(location: $0).validate()
            
            switch result {
            case .valid:
                return true
            case let .invalid(errors):
                print(errors)
                return false
            }
        }
        .map { $0[keyPath: keyPath] }
    }
    
    public func filter(of data: [Location]) -> [Location] {
        data.filter { LocationValidator(location: $0).validate() == .valid }
    }
}

public struct LocationValidator: Validator {
    private let location: Location

    public init(location: Location) {
        self.location = location
    }
    
    public var body: some Validator {
        AccuracyValidator(accuracy: location.accuracy)
        SpeedValidator(speed: location.speed)
    }
}

public struct AccuracyValidator: Validator {
    private let accuracy: Accuracy
    
    public init(accuracy: Accuracy) {
        self.accuracy = accuracy
    }
    
    public var body: some Validator {
        RangeValidator(with: 0...10, for: accuracy.horizontal)
        RangeValidator(with: 0...10, for: accuracy.vertical)
        RangeValidator(with: 0...2, for: accuracy.speed)
        RangeValidator(with: 0..., for: accuracy.course)
    }
}
 
public struct SpeedValidator: Validator {
    let speed: Speed
    
    public init(speed: Speed) {
        self.speed = speed
    }
    
    public var body: some Validator {
        RangeValidator(with: 1...37, for: speed)
    }
}
