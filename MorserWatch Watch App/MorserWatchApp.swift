//
//  MorserWatchApp.swift
//  MorserWatch Watch App
//
//  Created by Giuseppe Francione on 24/05/24.
//

import SwiftUI
import WatchConnectivity
import UIKit
@main
struct MorserWatch_Watch_AppApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ParentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .onAppear {
                    WatchCommunicationManager.shared.managedContext = dataController.container.viewContext
                }
        }
    }
}
