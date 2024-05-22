//
//  ContentView.swift
//  iKnowYou
//
//  Created by Kenneth Oliver Rathbun on 5/14/24.
//

import SwiftUI
import SwiftData

@Model
class Friend: Hashable {
    var name: String
    @Attribute(.externalStorage) var image: Data?
    
    init(name: String = "New Friend", image: Data? = nil) {
        self.name = name
        self.image = image
    }
    
    static var example: Friend {
        let photo = Friend()
        photo.name = "Red Panda"
        
        let uiImage = UIImage(resource: .redpanda)
        let imageData = uiImage.pngData()
        photo.image = imageData
        
        return photo
    }
}

struct ContentView: View {
    @Query private var friends: [Friend]
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(friends) { friend in
                    NavigationLink(friend.name, value: friend)
                }
                .onDelete(perform: deletePhoto)
            }
            .navigationTitle("IKnowYou")
            .toolbar {
                ToolbarItem {
                    NavigationLink {
                        AddNewPhotoView()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationDestination(for: Friend.self) { friend in
                PhotoCard(friend: friend)
                    .frame(width: .infinity, height: 600)
            }
        }
    }
    
    func deletePhoto(_ indexSet: IndexSet) {
        for index in indexSet {
            modelContext.delete(friends[index])
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Friend.self])
}
