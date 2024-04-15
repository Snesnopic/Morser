//
//  MorserApp.swift
//  Morser
//
//  Created by Giuseppe Francione on 15/04/24.
//

import SwiftUI
import SwiftData

@main
struct MorserApp: App {
    var body: some Scene {
        WindowGroup {
            ParentView()
        }
        .modelContainer(for: Sentence.self)
    }
}
