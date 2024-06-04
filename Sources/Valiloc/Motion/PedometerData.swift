//
//  File.swift
//  
//
//  Created by Pfriedrix on 04.06.2024.
//

import Foundation

public struct PedometerData: Codable {
    /*
     * currentPace
     *
     *
     * Discussion:
     *      For updates this returns the current pace, in s/m (seconds per meter).
     *      Value is nil if any of the following are true:
     *
     *         (1) Information not yet available;
     *         (2) Historical query;
     *         (3) Unsupported platform.
     *
     */
    public var currentPace: Double
    
    /*
     * averageActivePace
     *
     *
     * Discussion:
     *
     *      For updates this returns the average active pace since
     *      startPedometerUpdatesFromDate:withHandler:, in s/m (seconds per meter).
     *      For historical queries this returns average active pace between startDate
     *      and endDate. The average active pace omits the non-active time, giving
     *      the average pace from when the user was moving. Value is nil if any of
     *      the following are true:
     *
     *         (1) (For historical queries) this information is not available,
     *             e.g. the user did not move between startDate and endDate;
     *         (2) Unsupported platform.
     *
     */
    public var averageActivePace: Double
    
    public var timestamp: TimeInterval
}
