//
//  ImageLoader.swift
//  iKnowYou
//
//  Created by Kenneth Oliver Rathbun on 5/21/24.
//

import SwiftUI
import PhotosUI

struct ImageLoader {
    static func loadImage(from selectedImage: PhotosPickerItem?) async -> Image? {
        guard let data = try? await selectedImage?.loadTransferable(type: Data.self),
              let uiImage = UIImage(data: data)
        else {
            return nil
        }
        
        return Image(uiImage: uiImage)
    }
}
