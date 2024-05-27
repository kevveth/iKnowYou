//
//  PhotoCard.swift
//  iKnowYou
//
//  Created by Kenneth Oliver Rathbun on 5/17/24.
//

import SwiftUI
import SwiftData

import CoreImage
import PhotosUI
import StoreKit

import MapKit

struct PhotoCard: View {
    var friend: Friend
    @State private var title: String?
    
    @State private var selectedImage: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var image: Image?
 
    @State private var location: Location?
    
    init(friend: Friend) {
        self.friend = friend
        _title = State(initialValue: friend.name)
        _imageData = State(initialValue: friend.image)
        loadImage()
        _location = State(initialValue: friend.location)
    }
    
    var startPosition: MapCameraPosition? {
        if let coordinate = location?.coordinate.clLocationCoordinate2D {
            let position = MapCameraPosition.region(
                MKCoordinateRegion (
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
            )
            
            return position
        } else {
            return nil
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            PhotosPicker(selection: $selectedImage) {
                if let image {
                    image
                        .resizable()
                        .scaledToFit()
                } else {
                    ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Import a photo"))
                }
            }
            .onAppear {
                Task {
                    guard let imageData, let uiImage = UIImage(data: imageData) else { return }
                    image = Image(uiImage: uiImage)
                }
            }
            .onChange(of: selectedImage, loadImage)
            
            Text(title ?? "New Friend")
                .font(.title)
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.blue)
            
            if let startPosition {
                Map(initialPosition: startPosition)
                    .frame(height: 200)
                    .padding()
            } else {
                Text("No Location.")
            }
            
        }
        .clipShape(.rect(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.secondary, lineWidth: 3)
        }
        .padding()
    }
    
    func loadImage() {
        Task {
            guard
                let data = try await selectedImage?.loadTransferable(type: Data.self),
                let uiImage = UIImage(data: data)
            else {
                return
            }
            
            let loadedImage = Image(uiImage: uiImage)
            image = loadedImage
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Friend.self, configurations: config)
        
        return PhotoCard(friend: Friend.example)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
