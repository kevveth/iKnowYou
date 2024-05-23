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
    var location: CLLocationCoordinate2D?
    
    init(name: String = "New Friend", image: Data? = nil, location: CLLocationCoordinate2D? = nil) {
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
        friend.location = CLLocationCoordinate2D(latitude: 32.8578, longitude: -117.2577)
        
        return friend
    }
    #endif
}
