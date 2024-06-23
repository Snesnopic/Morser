//
//  WatchCommunicationManager.swift
//  MorserWatch Watch App
//
//  Created by Giuseppe Francione on 24/05/24.
//

import Foundation
import SwiftUI
import WatchConnectivity
import CoreData

class WatchCommunicationManager: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = WatchCommunicationManager()
    var managedContext: NSManagedObjectContext?
    private override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    func sendVibrationRequest(_ message: String) {
        WCSession.default.transferUserInfo(["action": "vibrate", "message": message, "maxDate": Date.now.addingTimeInterval(3)])
    }

    func sendStopRequest() {
        WCSession.default.transferUserInfo(["action": "stop"])
    }
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        print(userInfo)
        if let action = userInfo["action"] as? String {
            switch action {
            case "settings":
                @AppStorage("sliderPreference") var sliderPreference = 1.0
                @AppStorage("soundFrequency") var soundFrequency = 600.0
                @AppStorage("softwareFlashlight") var softwareFlashlight = true
                if let slp = userInfo["sliderPreference"]! as? Double, let sof = userInfo["soundFrequency"]! as? Double, let flash = userInfo["softwareFlashlight"]! as? Bool {
                    sliderPreference = slp
                    soundFrequency = sof
                    softwareFlashlight = flash
                    VibrationEngine.shared.updateTimings()
                    print("Ricevute dall'iPhone settings: \(sliderPreference) e \(soundFrequency)")
                }
            case "sentences":
                if let dict = userInfo["dict"] as? [Int32: String] {
                    print(dict)
                    do {
                        let fetchRequest = Sentence.fetchRequest()
                        let items = try? managedContext!.fetch(fetchRequest)
                        for item in items ?? [] {
                            managedContext!.delete(item)
                        }
                        try managedContext!.save()

                        try dict.forEach { order, sentence in
                            print("Frase attuale: \(sentence)")
                            let newSentence: Sentence = Sentence(context: managedContext!)
                            newSentence.order = order
                            newSentence.sentence = sentence
                            try managedContext!.save()
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }

            default:

                break
            }
        }
    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    func sessionReachabilityDidChange(_ session: WCSession) {}
}
