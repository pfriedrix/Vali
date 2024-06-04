//
//  MapView.swift
//
//
//  Created by Pfriedrix on 20.05.2024.
//

import SwiftUI
import MapKit
import Valiloc
import Charts
import Foundation

@available(macOS 14.0, *)
@available(iOS 17.0, *)
struct MapView: View {
    @State private var position = MapCameraPosition.region(.init(center: CLLocationCoordinate2D(latitude: 50.4501, longitude: 30.5234), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)))
    
    @State var original: [Location] = []
    @State var filteredKalman: [Location] = []
    @State var ekf: [Location] = []
    @State var locationFilterCoordinates: [Location] = []
    
    var body: some View {
        VStack {
            Map(position: $position) {
                MapPolyline(coordinates: original.compactMap {
                    CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
                }).stroke(.blue, lineWidth: 6)
//                MapPolyline(coordinates: locationFilterCoordinates.compactMap {
//                    CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
//                }).stroke(.yellow, lineWidth: 2)
                MapPolyline(coordinates: filteredKalman.compactMap {
                    CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
                }).stroke(.yellow, lineWidth: 2)
                //                MapPolyline(coordinates: ekf.compactMap {
                //                    CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
                //                }).stroke(.blue, lineWidth: 6)
            }
            .mapStyle(.standard(pointsOfInterest: []))
            .onAppear {
                do {
                    let locations = try Location.loadMocks()
                    original = locations
                    let locationFilter = LocationFilter()
                    locationFilterCoordinates = locationFilter.filter(of: locations)
                    if let first = locations.first {
                        let filter = KalmanFilter(initial: first, processNoise: 1, measurementNoise: 1)
                        filteredKalman = filter.filter(of: original)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            let minValue = original.map { $0.altitude }.min() ?? 0
            let maxValue = original.map { $0.altitude }.max() ?? 0
            let padding = (maxValue - minValue) * 0.1
            Text("Висота:")
                .padding(.top)
                .padding(.horizontal)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            Chart {
                ForEach(Array(original.enumerated()), id: \.offset) { index, location in
                    LineMark(
                        x: .value("Index", index),
                        y: .value("Altitude", location.altitude)
                    )
                    .foregroundStyle(by: .value("Locations", "Origin"))
                }
//                ForEach(Array(locationFilterCoordinates.enumerated()), id: \.offset) { index, location in
//                    LineMark(
//                        x: .value("Index", index),
//                        y: .value("Altitude", location.altitude)
//                    )
//                    .foregroundStyle(by: .value("Locations", "Limited"))
//                }
                ForEach(Array(filteredKalman.enumerated()), id: \.offset) { index, location in
                    LineMark(
                        x: .value("Index", index),
                        y: .value("Altitude", location.altitude)
                    )
                    .foregroundStyle(by: .value("Locations", "Kalman"))
                }
                //                ForEach(Array(ekf.enumerated()), id: \.offset) { index, location in
                //                    LineMark(
                //                        x: .value("Index", index),
                //                        y: .value("Altitude", location.altitude)
                //                    )
                //                    .foregroundStyle(by: .value("Locations", "EKF"))
                //                }
            }
            .chartXAxis(.hidden)
            .chartYAxis {
                AxisMarks(position: .trailing) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel() {
                        if let doubleValue = value.as(Double.self) {
                            Text(String(format: "%.0f m", doubleValue))
                        }
                    }
                }
            }
            .chartYScale(domain: (minValue - padding)...(maxValue + padding))
            .frame(height: 200)
            .padding()
        }
    }
    
    func calculateDistance<F: Filter>(_ locations: [Location], filter: F) -> Double where F.Item == Location {
        let measurer = LocationMeasurer(filter: filter)
        return measurer.distance(of: locations, for: .kilometers).value
    }
}

struct ColoredPolyline: Identifiable {
    let id = UUID()
    let coordinates: [CLLocationCoordinate2D]
    let color: Color
}

@available(iOS 16.0, *)
@available(macOS 13.0, *)
extension Location: Plottable {
    public init?(primitivePlottable: Double) {
        self.init(coordinate: .zero, accuracy: .zero, speed: .zero, altitude: primitivePlottable, timestamp: Date())
    }
    
    public typealias PrimitivePlottable = Double
    public var primitivePlottable: Double {
        altitude
    }
}
