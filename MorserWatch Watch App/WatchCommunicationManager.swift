//
//  WatchCommunicationManager.swift
//  MorserWatch Watch App
//
//  Created by Giuseppe Francione on 24/05/24.
//

import Foundation
import SwiftUI
import WatchConnectivity

class WatchCommunicationManager: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = WatchCommunicationManager()

    private override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    func sendVibrationRequest(_ message: String) {
        WCSession.default.transferUserInfo(["action": "vibrate", "message": message])
    }
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        print(userInfo)
        if let action = userInfo["action"] as? String {
            switch action {
            case "settings":
                @AppStorage("sliderPreference") var sliderPreference = 1.0
                @AppStorage("soundFrequency") var soundFrequency = 600.0
                if let slp = userInfo["sliderPreference"]! as? Double, let sof = userInfo["soundFrequency"]! as? Double {
                    sliderPreference = slp
                    soundFrequency = sof
                    VibrationEngine.shared.updateTimings()
                    print("Ricevute dall'iPhone settings: \(sliderPreference) e \(soundFrequency)")
                }
            default:

                break
            }
        }
    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    func sessionReachabilityDidChange(_ session: WCSession) {}
}
