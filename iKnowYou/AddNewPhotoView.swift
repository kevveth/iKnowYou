//
//  AddNewPhotoView.swift
//  iKnowYou
//
//  Created by Kenneth Oliver Rathbun on 5/16/24.
//

import SwiftUI

import CoreImage
import PhotosUI
import StoreKit

import MapKit

import SwiftData

struct AddNewPhotoView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var processedImage: Image?
    @State private var selectedImage: PhotosPickerItem?
    
    @State private var friend = Friend()
    
    @State var name: String = ""
    @State var imageData: Data? = nil
    @State var currentLocation: Location? = nil
    
    @State private var currentCoordinate: CLLocationCoordinate2D?
    private let locationFetcher = LocationFetcher()
    
    init() {
        locationFetcher.start()
    }
    
    var body: some View {
        VStack {
            Form {
                Section("Image") {
                    PhotosPicker(selection: $selectedImage) {
                        if let processedImage {
                            processedImage
                                .resizable()
                                .scaledToFit()
                        } else {
                            ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Import a photo"))
                        }
                    }
                    .onChange(of: selectedImage) {
                        Task {
                            processedImage = await ImageLoader.loadImage(from: selectedImage)
                        }
                    }
                }
                Section("Name") {
                    HStack {
                        TextField("Enter name", text: $name)
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: name) {
                                friend.name = name
                            }
                    }
                }
                
                Section("Location") {
                    if let coordinate = currentCoordinate {
                        let position = MapCameraPosition.region(
                            MKCoordinateRegion(
                                center: coordinate,
                                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
                        )
                        
                        Map(initialPosition: position)
                            .frame(height: 200)
                    } else {
                        Text("Fetching locaiton...")
#if DEBUG
                        Text("Coordinate: \(String(describing: currentCoordinate))")
#endif
                    }
                }
            }
        }
        //        .frame(maxWidth: .infinity)
        .navigationTitle("Add a New Friend")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    addNewPhoto()
                    dismiss()
                }
            }
        }
        .onAppear {
            //            locationFetcher.start()
            if let coordinate = locationFetcher.lastKnownLocation {
                currentCoordinate = coordinate
            }
        }
    }
    
    func addNewPhoto() {
        Task {
            guard let image = try await selectedImage?.loadTransferable(type: Data.self) else { return }
            if let currentCoordinate {
                currentLocation = Location(coordinate: Coordinate(from: currentCoordinate))
                let newPhoto = Friend(name: name, image: image, location: currentLocation)
                modelContext.insert(newPhoto)
            } else {
                print("Unable to add new photo.")
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Friend.self, configurations: config)
        
        return AddNewPhotoView()
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
