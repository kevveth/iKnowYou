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
    @State private var title: String
    @State private var selectedImage: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var image: Image?
    @State private var location: Location?
    
    init(friend: Friend) {
        self.friend = friend
        _title = State(initialValue: friend.name)
        _imageData = State(initialValue: friend.image)
        _location = State(initialValue: friend.location)
    }
    
    var startPosition: MapCameraPosition? {
        if let coordinate = location?.coordinate.clLocationCoordinate2D {
            return MapCameraPosition.region(
                MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
            )
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
                if let imageData, let uiImage = UIImage(data: imageData) {
                    image = Image(uiImage: uiImage)
                }
            }
            .onChange(of: selectedImage) {
                Task {
                    image = await ImageLoader.loadImage(from: selectedImage)
                }
            }
            
            Text(title)
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
            
            if let startPosition = startPosition {
                Map(initialPosition: startPosition)
                    .frame(height: 200)
                    .padding()
            } else {
                Text("No Location.")
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.secondary, lineWidth: 3)
        }
        .padding()
    }
}

//#Preview {
//    do {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: Friend.self, configurations: config)
//        
//        return PhotoCard(friend: Friend.example)
//            .modelContainer(container)
//    } catch {
//        return Text("Failed to create preview: \(error.localizedDescription)")
//    }
//}
