//
//  Friend.swift
//  iKnowYou
//
//  Created by Kenneth Oliver Rathbun on 5/23/24.
//

import SwiftUI
import SwiftData
import CoreLocation

@Model
class Friend: Hashable {
    var name: String
    @Attribute(.externalStorage) var image: Data?
    @Relationship(deleteRule: .cascade) var location: Location?
    
    init(name: String = "New Friend", image: Data? = nil, location: Location? = nil) {
        self.name = name
        self.image = image
        self.location = location
    }
    
    #if DEBUG
    static var example: Friend {
        let friend = Friend()
        friend.name = "Red Panda"
        
        let uiImage = UIImage(resource: .redpanda)
        let imageData = uiImage.pngData()
        friend.image = imageData
        
        // La Jolla Shores
        let coordinate = Coordinate(latitutude: 32.8578, longitude: -117.2577)
        friend.location = Location(name: "La Jolla Shores", coordinate: coordinate)
        
        return friend
    }
    #endif
}
