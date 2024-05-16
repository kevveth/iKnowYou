//
//  iKnowYouApp.swift
//  iKnowYou
//
//  Created by Kenneth Oliver Rathbun on 5/14/24.
//

import SwiftUI

@main
struct iKnowYouApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Photo.self])
    }
}
