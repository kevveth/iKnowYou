//
//  Location.swift
//  iKnowYou
//
//  Created by Kenneth Oliver Rathbun on 5/23/24.
//

import Foundation
import CoreLocation
import SwiftData

struct Coordinate: Codable {
    var latitutude: Double
    var longitude: Double
    
    var clLocationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitutude, longitude: longitude)
    }
    
    init(latitutude: Double, longitude: Double) {
        self.latitutude = latitutude
        self.longitude = longitude
    }
    
    init(from coordinate: CLLocationCoordinate2D) {
        self.latitutude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
}

@Model
final class Location: Codable {
    var name: String
    var coordinate: Coordinate
    
    init(name: String = "Met Location", coordinate: Coordinate) {
        self.name = name
        self.coordinate = coordinate
    }
    
    enum CodingKeys: CodingKey {
        case name
        case coordinate
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(coordinate, forKey: .coordinate)
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
    }
}
