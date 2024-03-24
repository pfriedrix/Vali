//
//  File.swift
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
}
