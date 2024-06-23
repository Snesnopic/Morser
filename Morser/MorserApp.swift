//
//  MorserApp.swift
//  Morser
//
//  Created by Giuseppe Francione on 15/04/24.
//

import SwiftUI
#if os(iOS)
import WatchConnectivity
#endif
@main
struct MorserApp: App {
#if os(iOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ParentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
#if os(iOS)
                .onAppear {
                    WatchConnectivityProvider.shared.managedContext = dataController.container.viewContext
                    if !VibrationEngine.shared.supportsHaptics {
                        @AppStorage("soundEnabled") var soundEnabled = true
                        soundEnabled = true
                    }
                }
            #endif
        }
#if os(macOS)
       Settings {
           SettingsView()
       }
       #endif
    }
}
#if os(iOS)
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        WatchConnectivityProvider.shared.activate()
        return true
    }
}
#endif
