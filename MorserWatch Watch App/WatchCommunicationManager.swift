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

    func sendVibrationRequest() {
            WCSession.default.transferUserInfo(["action": "vibrate", "message": "sos"])
    }
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {

    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    func sessionReachabilityDidChange(_ session: WCSession) {}
}
