//
//  WatchConnectivityProvider.swift
//  Morser
//
//  Created by Giuseppe Francione on 24/05/24.
//

import Foundation
import WatchConnectivity
import Combine
import CoreHaptics
import SwiftUI

class WatchConnectivityProvider: NSObject, ObservableObject, WCSessionDelegate {
    static let shared = WatchConnectivityProvider()

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
        if let action = userInfo["action"] as? String, let message = userInfo["message"] as? String {
            print("\(message)")
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

    private func vibrateDevice() {
        //        DispatchQueue.main.async {
        //            let generator = UIImpactFeedbackGenerator(style: .medium)
        //            generator.impactOccurred()
        //        }
        //    }
    }
}
