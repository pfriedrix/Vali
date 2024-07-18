//
//  LocationFilter.swift
//  
//
//  Created by Pfriedrix on 25.03.2024.
//

public struct LocationFilter: Filter {
    public init() { }
    
    public func filter<Value>(of data: [Location], for keyPath: KeyPath<Item, Value>) -> [Location] {
        data.compactMap {
            let result = LocationValidator(location: $0).validate()
            
            switch result {
            case .valid:
                return $0
            case let .invalid(error):
                let errors = error.errors.filter {
                    return $0.keyPath == keyPath
                }
                if errors.isEmpty {
                    return $0
                }

                return nil
            }
        }
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
        AccuracyValidator(accuracy: location.accuracy, keyPath: \.accuracy)
        SpeedValidator(speed: location.speed)
    }
}

public struct AccuracyValidator: Validator {
    private let accuracy: Accuracy
    private let keyPath: KeyPath<Location, Accuracy>
    
    public init(accuracy: Accuracy, keyPath: KeyPath<Location, Accuracy>) {
        self.accuracy = accuracy
        self.keyPath = keyPath
    }
    
    public var body: some Validator {
        RangeValidator(with: 0...10, for: accuracy.horizontal, keyPath: keyPath.appending(path: \.horizontal))
        RangeValidator(with: 0...10, for: accuracy.vertical, keyPath: keyPath.appending(path: \.vertical))
        RangeValidator(with: 0...2, for: accuracy.speed, keyPath: keyPath.appending(path: \.speed))
        RangeValidator(with: 0..., for: accuracy.course, keyPath: keyPath.appending(path: \.course))
    }
}
 
public struct SpeedValidator: Validator {
    let speed: Speed
    
    public init(speed: Speed) {
        self.speed = speed
    }
    
    public var body: some Validator {
        RangeValidator(with: 1...37, for: speed, keyPath: \Accuracy.speed)
    }
}
