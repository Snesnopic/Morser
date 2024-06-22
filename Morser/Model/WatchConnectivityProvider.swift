//
//  WatchConnectivityProvider.swift
//  Morser
//
//  Created by Giuseppe Francione on 24/05/24.
//
#if os(iOS)
import Foundation
import WatchConnectivity
import Combine
import CoreHaptics
import SwiftUI
import CoreData

class WatchConnectivityProvider: NSObject, ObservableObject, WCSessionDelegate {
    static let shared = WatchConnectivityProvider()
    var managedContext: NSManagedObjectContext?

    private override init() {
        super.init()
    }

    func activate() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Handle activation completion
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        // Handle session inactivity
    }

    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    func session(_ session: WCSession, didReceive file: WCSessionFile) {

    }
    static func sendSettingsToWatch() {
        @AppStorage("sliderPreference") var sliderPreference = 1.0
        @AppStorage("soundFrequency") var soundFrequency = 600.0
        WCSession.default.transferUserInfo(["action": "settings", "sliderPreference": sliderPreference, "soundFrequency": soundFrequency])
        print("Mandate al watch settings: \(sliderPreference) e \(soundFrequency)")
    }
    @MainActor func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        if let action = userInfo["action"] as? String, action == "vibrate", let message = userInfo["message"] as? String {
            let maxDate = userInfo["maxDate"] as? Date
            if maxDate! >= .now {
                DispatchQueue.main.async {
                    if VibrationEngine.shared.engine == nil {
                        do {
                            VibrationEngine.shared.engine = try CHHapticEngine()
                        } catch {
                            print(error)
                        }
                    }
                    VibrationEngine.shared.readMorseCode(morseCode: message.morseCode())
                }
            }
        }
    }

    static func sendSentencesToWatch() {
        var message: [String: Any] = ["action": "sentences"]
        let fetchRequest = Sentence.fetchRequest()
        let sentences = try? WatchConnectivityProvider.shared.managedContext!.fetch(fetchRequest)
        var dict: [Int32: String] = [:]
        sentences?.forEach({ sentence in
            dict[sentence.order] = sentence.sentence!
        })
        message["dict"] = dict
        WCSession.default.transferUserInfo(message)
        print("Mandate al watch sentences: \(message)")
    }
}
#endif
