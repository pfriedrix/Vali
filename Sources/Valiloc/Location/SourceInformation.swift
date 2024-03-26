//
//  SourceInformation.swift
//  
//
//  Created by Pfriedrix on 21.03.2024.
//

public struct SourceInformation: Codable {
    let isPruducedByAccessory: Bool
    let isSimulatedBySoftware: Bool
    
    public init(isPruducedByAccessory: Bool, isSimulatedBySoftware: Bool) {
        self.isPruducedByAccessory = isPruducedByAccessory
        self.isSimulatedBySoftware = isSimulatedBySoftware
    }
    
    public init?(isPruducedByAccessory: Bool?, isSimulatedBySoftware: Bool?) {
        guard let isPruducedByAccessory = isPruducedByAccessory,
              let isSimulatedBySoftware = isSimulatedBySoftware else { return nil }
        self.isPruducedByAccessory = isPruducedByAccessory
        self.isSimulatedBySoftware = isSimulatedBySoftware
    }
}
