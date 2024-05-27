//
//  ContentView.swift
//  iKnowYou
//
//  Created by Kenneth Oliver Rathbun on 5/14/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var friends: [Friend]
    @Environment(\.modelContext) var modelContext
    
    var locationFetcher = LocationFetcher()
    
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
                    .frame(maxWidth: .infinity)
            }
            
            VStack {
                        Button("Start Tracking Location") {
                            locationFetcher.start()
                        }

                        Button("Read Location") {
                            if let location = locationFetcher.lastKnownLocation {
                                print("Your location is \(location)")
                            } else {
                                print("Your location is unknown")
                            }
                        }
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
