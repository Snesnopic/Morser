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
                .onAppear {
                    WatchConnectivityProvider.shared.managedContext = dataController.container.viewContext
                    if !VibrationEngine.shared.supportsHaptics {
                        @AppStorage("soundEnabled") var soundEnabled = true
                        soundEnabled = true
                    }
                }
        }
    }
}

import Intents
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        WatchConnectivityProvider.shared.activate()
        return true
    }
    func application(_ application: UIApplication, handlerFor intent: INIntent) -> Any? {
        if intent is EncodeMorseIntent {
            return EncodeMorseIntentHandler()
        }
        return nil
    }
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.type == "com.snesnopic.morser" {
            // Handle the quick action
            // Present a view controller or encode a predefined text
            let text = "Sample text"
            VibrationEngine.shared.createEngine()
            VibrationEngine.shared.readMorseCode(morseCode: text.morseCode())
            completionHandler(true)
        } else {
            completionHandler(false)
        }
    }

}
