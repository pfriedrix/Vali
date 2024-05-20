//
//  MapView.swift
//  
//
//  Created by Pfriedrix on 20.05.2024.
//

import SwiftUI
import MapKit
import Valiloc

@available(macOS 14.0, *)
@available(iOS 17.0, *)
struct MapView: View {
    @State private var position = MapCameraPosition.region(.init(center: CLLocationCoordinate2D(latitude: 50.4501, longitude: 30.5234), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)))

    @State var originalCoordinates: [CLLocationCoordinate2D] = []
    @State var filteredKalmanCoordinates: [CLLocationCoordinate2D] = []
    @State var locationFilterCoordinates: [CLLocationCoordinate2D] = []
    @State var locationCombineFilters: [CLLocationCoordinate2D] = []

    var body: some View {
        Map(position: $position) {
            MapPolyline(coordinates: originalCoordinates).stroke(.gray, lineWidth: 8)
            MapPolyline(coordinates: filteredKalmanCoordinates).stroke(.red, lineWidth: 6)
            MapPolyline(coordinates: locationFilterCoordinates).stroke(.blue, lineWidth: 4)
            MapPolyline(coordinates: locationCombineFilters).stroke(.pink, lineWidth: 2)
            
        }
        .mapControlVisibility(.visible)
        .onAppear {
            do {
                let locations = try Location.loadMocks()
                originalCoordinates = locations.compactMap {
                    CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
                }
                if let first = locations.first {
                    let filter = KalmanFilter(initial: first, processNoise: 0.1, measurementNoise: 0.1)
                    filteredKalmanCoordinates = filter.filter(of: locations).compactMap {
                        CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
                    }
                }
                let locationFilter = LocationFilter()
                locationFilterCoordinates = locationFilter.filter(of: locations).compactMap {
                    CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
                }
                if let first = locations.first {
                    let locationFilter = LocationFilter()
                    let filter = KalmanFilter(initial: first, processNoise: 1, measurementNoise: 0.5)
                    locationCombineFilters = filter.filter(of: locationFilter.filter(of: locations)).compactMap {
                        CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct ColoredPolyline: Identifiable {
    let id = UUID()
    let coordinates: [CLLocationCoordinate2D]
    let color: Color
}
