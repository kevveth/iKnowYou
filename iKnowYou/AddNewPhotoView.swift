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
import SwiftData

struct AddNewPhotoView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var processedImage: Image?
    @State private var selectedImage: PhotosPickerItem?
    
    @State private var friend = Friend()
    
    @State var name: String = ""
    @State var imageData: Data? = nil
    
    init(selectedImage: PhotosPickerItem? = nil) {
        self.selectedImage = selectedImage
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
    }
    
    func addNewPhoto() {
        Task {
            guard let imageData = try await selectedImage?.loadTransferable(type: Data.self) else { return }
            let newPhoto = Friend(name: name, image: imageData)
            modelContext.insert(newPhoto)
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
