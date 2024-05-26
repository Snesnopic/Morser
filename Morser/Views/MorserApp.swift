//
//  MorserApp.swift
//  Morser
//
//  Created by Giuseppe Francione on 15/04/24.
//

import SwiftUI
import WatchConnectivity

@main
struct MorserApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ParentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        WatchConnectivityProvider.shared.activate()
        return true
    }
}
