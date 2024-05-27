//
//  Location.swift
//  iKnowYou
//
//  Created by Kenneth Oliver Rathbun on 5/23/24.
//

import Foundation
import CoreLocation
import SwiftData

/// Represents a geographic coordinate with latitude and longitude.
struct Coordinate: Codable {
    var latitude: Double
    var longitude: Double
    
    /// Converts the `Coordinate` to `CLLocationCoordinate2D`.
    var clLocationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    /// Initializes a `Coordinate` with latitude and longitude values.
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    /// Initializes a `Coordinate` from a `CLLocationCoordinate2D`.
    init(from coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
}

@Model
final class Location {
    var name: String
    var coordinate: Coordinate
    
    /// Initializes a `Location` with a name and coordinate.
    init(name: String = "Met Location", coordinate: Coordinate) {
        self.name = name
        self.coordinate = coordinate
    }
}
