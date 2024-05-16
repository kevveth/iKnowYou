//
//  ContentView.swift
//  iKnowYou
//
//  Created by Kenneth Oliver Rathbun on 5/14/24.
//

import SwiftUI
import SwiftData

import CoreImage
import PhotosUI
import StoreKit

@Model
class Photo {
    var name: String?
    @Attribute(.externalStorage) var image: Data?
    
    init(name: String? = nil, image: Data? = nil) {
        self.name = name
        self.image = image
    }
}

struct ContentView: View {
    @Query private var photos: [Photo]
    
    @State private var selectedImage: PhotosPickerItem?
    @State private var proccessedImage: Image?
    
    var body: some View {
        NavigationStack {
            VStack {
                PhotosPicker(selection: $selectedImage)
                {
                    if let proccessedImage {
                        proccessedImage
                            .resizable()
                            .scaledToFill()
                    } else {
                        ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
                    }
                }
                .onChange(of: selectedImage, loadImage)
                .border(.green, width: 2)
            }
            .padding()
        }
    }
    
    func loadImage() {
        Task {
            guard let imageData = try await selectedImage?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }
            proccessedImage = Image(uiImage: inputImage)
            
        }
    }
}

#Preview {
    ContentView()
}
